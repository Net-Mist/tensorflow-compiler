import logging
import coloredlogs
import tensorflow as tf
from tensorflow import keras
from generic_benchmark import download_images, ClassificationBenchmark

coloredlogs.install(level="WARN")


class KerasBenchmark(ClassificationBenchmark):
    def __init__(self, path_to_images, image_size, batch_size, model, model_name):
        super().__init__(path_to_images, image_size, batch_size, model_name)
        self.model = model

        # First run to prepare
        for i in range(5):
            self.get_proba(self.batch_list[i])

    def get_proba(self, images_batch):
        # return self.model(tf.constant(images_batch, dtype=tf.float32))['NASNet'].numpy()
        return self.model.predict_on_batch(images_batch)


def main():
    download_images(100)
    fps = {}
    
    # model = keras.applications.ResNet50(include_top=True, weights='imagenet', input_tensor=None, input_shape=None, pooling=None, classes=1000)
    # model = keras.applications.InceptionV3()
    model = keras.applications.MobileNetV2()
    b = KerasBenchmark("images", 224, 1, model, "ResNet50")
    fps["ResNet50"] = b.run()
    

    # with tf.Session() as sess:
    #     tf.keras.backend.set_session(sess)
    #     
    #     b = KerasBenchmark("images", 299, 1, model, "InceptionV3")
    #     fps["InceptionV3"] = b.run()
    
    # with tf.Session() as sess:
    #     tf.keras.backend.set_session(sess)
    #     model = keras.applications.InceptionResNetV2()
    #     b = KerasBenchmark("images", 299, 1, model, "InceptionResNetV2")
    #     fps["InceptionResNetV2"] = b.run()
    
    # with tf.Session() as sess:
    #     tf.keras.backend.set_session(sess)
    #     model = keras.applications.VGG16()
    #     b = KerasBenchmark("images", 224, 1, model, "VGG16")
    #     fps["VGG16"] = b.run()

    # with tf.Session() as sess:
    #     tf.keras.backend.set_session(sess)
    #     model = keras.applications.Xception()
    #     b = KerasBenchmark("images", 299, 1, model, "Xception")
    #     fps["Xception"] = b.run()
    
    # with tf.Session() as sess:
    #     tf.keras.backend.set_session(sess)
    #     model = keras.applications.MobileNet()
    #     b = KerasBenchmark("images", 224, 1, model, "MobileNet")
    #     fps["MobileNet"] = b.run()

    # with tf.Session() as sess:
    #     tf.keras.backend.set_session(sess)
    #     model = keras.applications.MobileNetV2()
    #     b = KerasBenchmark("images", 224, 1, model, "MobileNetV2")
    #     fps["MobileNetV2"] = b.run()
    
    print(fps)


if __name__ == "__main__":
    main()
