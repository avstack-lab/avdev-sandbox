import os

import avapi
import avstack


dir_path = os.path.dirname(os.path.realpath(__file__))
data_dir = os.path.join(dir_path, "..", "..", "data")


if __name__ == "__main__":
    # -- load perception models
    try:
        M2D = avstack.modules.perception.object2dfv.MMDetObjectDetector2D(
            dataset="cityscapes", model="fasterrcnn"
        )
        M3D = avstack.modules.perception.object3d.MMDetObjectDetector3D(
            dataset="kitti", model="pointpillars"
        )
    except Exception as e:
        print("\nLoading perception models FAILED!")
        raise e
    else:
        print("\nLoading perception models SUCCEEDED\n")

    # -- perform inference
    try:
        data_path = os.path.join(data_dir, "KITTI", "object")
        SM = avapi.kitti.KittiScenesManager(data_path)
        DM = SM.get_scene_dataset_by_index(0)

        # -- image inference
        img = DM.get_image(DM.frames[0], sensor="image-2")
        dets_2d = M2D(img)

        # -- lidar inference
        pc = DM.get_lidar(DM.frames[0], sensor="image-2")
        dets_3d = M3D(pc)

    except Exception as e:
        print("\nRunning perception inference FAILED!")
        raise e
    else:
        print("\nRunning perception inference SUCCEEDED\n")
