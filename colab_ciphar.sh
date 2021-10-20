# FROM README
# download packages
sudo apt install python3-dev python3-virtualenv python3-tk imagemagick
# install requirements
pip install -r requirements.txt

#export environment variables
export MLDATA ='data'
export PYTHONPATH='.:$PYTHONPATH'

# donwload cifar dataset
scripts/create_unlabeled.py $ML_DATA/SSL2/cifar10 $ML_DATA/cifar10-train.tfrecord

# Create semi-supervised subsets
for seed in 0 1 2 3 4 5; do
    for size in 1000; do
         scripts/create_split.py --seed=$seed --size=$size $ML_DATA/SSL2/cifar10 $ML_DATA/cifar10-train.tfrecord
    done
done

# running fixmatch via command line
python fixmatch.py --filters=32 --dataset=cifar10.3@1000-5000 --train_dir ./experiments/fixmatch
