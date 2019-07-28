import csv
import os
import requests
import logging
import time
import numpy as np
from typing import List
from tqdm import tqdm
from PIL import Image


def download_csv():
    """Download the csv file containing the links to open-images test dataset
    """
    if os.path.exists("images.csv"):
        logging.info("find file images.csv")
        return
    url = "https://storage.googleapis.com/cvdf-datasets/oid/open-images-dataset-test.tsv"
    response = requests.get(url, stream=True)
    with open("images.csv", "wb") as handle:
        for data in tqdm(response.iter_content()):
            handle.write(data)
    logging.info("file images.csv downloaded")
    return


def download_images(n_images: int):
    """Download images from open-images dataset

    Args:
        n_images (int): number of image to download
    """
    download_csv()
    os.makedirs("images", exist_ok=True)
    with open('images.csv') as csvfile:
        reader = csv.reader(csvfile, delimiter='\t')
        next(reader)  # Remove the first line

        n_downloaded_images = len(os.listdir("images"))
        logging.info(f"{n_downloaded_images} images already downloaded")
        if n_images <= n_downloaded_images:
            logging.info("do nothing")
            return
        n_images -= n_downloaded_images
        for i in range(n_downloaded_images):
            next(reader)

        for i, row in enumerate(reader):
            if i == n_images:
                return
            print(row[0])
            response = requests.get(row[0], stream=True)
            with open(f"images/{n_downloaded_images + i}.jpg", "wb") as handle:
                for data in response.iter_content():
                    handle.write(data)


def load_and_preprocess_image(image_filename, image_size, transpose=False, normalize=True):
    """load the image, crop a box then resize to image_size

    Args:
        image_filename (str): absolute path of the image
        image_size (int): should match placeholder size
        transpose (bool, optional): if True then change data layout from HWC to CHW. Defaults to False.
        normalize (bool, optional): if true normalize between -1 and 1. Defaults to True.

    Returns:
        np.ndarray: image ready for neural net
    """
    cache_dir = f"images_{image_size}"
    cache_file = os.path.join(cache_dir, os.path.split(image_filename)[1])
    if os.path.exists(cache_file):
        img = Image.open(cache_file)
    else:
        img = Image.open(image_filename)
        dx, dy = img.size
        delta = float(abs(dy - dx))
        if dx > dy:
            box = (int(delta / 2), 0, dy, int(dx - delta))  # left top width heigth of the crop
        else:
            box = (0, int(delta / 2), int(dy - delta), dx)
        img = img.crop(box)
        img = img.resize((image_size, image_size), Image.ANTIALIAS)
        os.makedirs(cache_dir, exist_ok=True)
        img.save(cache_file)

    mean = 128
    std = 1.0 / 128.0
    img = np.asarray(img, dtype=np.float32)
    if len(img.shape) == 2:
        img = np.stack((img,)*3, axis=-1)
    if normalize:
        for i in range(3):
            img[:, :, i] = (img[:, :, i] - mean) * std
    if transpose:
        img = img.transpose((2, 0, 1))  # Change data layout from HWC to CHW
    return img


def load_and_preprocess_images(images_dir, image_size, transpose=False, normalize=True):
    logging.info("start loading and processing images")
    img_list = []
    img_name_list = []
    files = os.listdir(images_dir)
    files.sort()
    for file in files:
        logging.debug(f"process {file}")
        image_filename = os.path.join(images_dir, file)
        img_name_list.append(image_filename)
        try:
            img_list.append(load_and_preprocess_image(image_filename, image_size, transpose, normalize))
        except OSError as e:
            logging.warning(f"Issue when loading image {file}: {e}")
    return img_list, img_name_list


def transform_to_batch_list(img_list: List[np.ndarray], batch_size: int):
    """Create the batch before feeding to neural net

    Args:
        img_list (List[np.ndarray]): list of images (ndarray of shape (H, W, C) or (C, H, W))
        batch_size (int): maximal number of images in one batch

    Returns:
        List[np.ndarray]: list of batches
    """

    n_batch_to_create = len(img_list) // batch_size
    batch_list = []

    # Create the batches
    if n_batch_to_create >= 1:
        for i in range(n_batch_to_create):
            batch = np.zeros((batch_size, img_list[0].shape[0], img_list[0].shape[1], img_list[0].shape[2]), dtype=np.float32)
            for j in range(batch_size):
                batch[j] = img_list[i + j]
            batch_list.append(batch)

    # And add one batch with less images, if we can't divide exactly the images.
    if len(img_list) % batch_size != 0:
        batch_list.append(transform_to_batch_list(img_list[n_batch_to_create * batch_size:], len(img_list) % batch_size))
    return batch_list


class GenericBenchmark:
    def __init__(self, path_to_images, image_size, batch_size, model_name):
        img_list, self.img_name_list = load_and_preprocess_images(path_to_images, image_size)
        self.number_of_images = len(img_list)
        self.batch_list = transform_to_batch_list(img_list, batch_size)
        self.model_name = model_name
        self.batch_size = batch_size

    def bench_function(self, batch, batch_id):
        """Need to be implemented in children classes
        
        Args:
            batch (np.ndarray): batch to process
            batch_id (int): id of the batch in the list
        """
        pass

    def run(self):
        start_time = time.time()
        for batch_id, batch in enumerate(self.batch_list):
            self.bench_function(batch, batch_id)
        logging.info("End of batch")
        end_time = time.time()

        print(f"Model: {self.model_name}")
        print("total time: {}".format(end_time - start_time))
        print("Mean time per image: {}".format((end_time - start_time) / self.number_of_images))

        # return FPS
        return self.number_of_images / (end_time - start_time)


class ClassificationBenchmark(GenericBenchmark):
    def __init__(self, path_to_images, image_size, batch_size, model_name):
        super().__init__(path_to_images, image_size, batch_size, model_name)

    def bench_function(self, images_batch, batch_id):
        proba = self.get_proba(images_batch)
        for i in range(proba.shape[0]):  # iterate on result per image
            output_proba = proba[i, :]

            top_inds = output_proba.argsort()[::-1][:5]

            logging.info(''.join(['*' for i in range(20)]))
            logging.info(self.img_name_list[((self.batch_size * batch_id) + i)])
            logging.info(''.join(['*' for i in range(20)]))

            for index in range(5):  # showing 5 top possibilities
                logging.info("{} {} {}".format(top_inds[index], top_inds[index], output_proba[top_inds[index]]))
            logging.info(''.join(['*' for i in range(20)]))

    def get_proba(self, images_batch):
        pass
