set -e

DATAFOLDER=${1:-./data}
DATAFOLDER=${DATAFOLDER%/}  # remove trailing slash

MODELFOLDER=${2:-./models}
MODELFOLDER=${MODELFOLDER%/}  # remove trailing slash


################################
# Download perception models
################################

./submodules/lib-avstack-core/models/download_mmdet_models.sh $MODELFOLDER
./submodules/lib-avstack-core/models/download_mmdet3d_models.sh $MODELFOLDER


################################
# Download AV datasets
################################

# -- kitti
./submodules/lib-avstack-api/data/download_KITTI_ImageSets.sh $DATAFOLDER
./submodules/lib-avstack-api/data/download_KITTI_object_data.sh $DATAFOLDER
./submodules/lib-avstack-api/data/download_KITTI_raw_data.sh $DATAFOLDER
./submodules/lib-avstack-api/data/download_KITTI_raw_tracklets.sh $DATAFOLDER

# -- nuscenes
./submodules/lib-avstack-api/data/download_nuScenes_mini.sh $DATAFOLDER

# -- carla (our custom)
./submodules/lib-avstack-api/data/download_CARLA_datasets.sh object-v1 $DATAFOLDER
./submodules/lib-avstack-api/data/download_CARLA_datasets.sh collab-v1 $DATAFOLDER
set +e
./submodules/lib-avstack-api/data/download_CARLA_datasets.sh collab-v2 $DATAFOLDER  || echo "Could not complete collab-v2 download...continuing"
set -e


# Link to the datasets
ln -sf ./submodules/lib-avstack-api/data data
./data/add_custom_symlinks.sh