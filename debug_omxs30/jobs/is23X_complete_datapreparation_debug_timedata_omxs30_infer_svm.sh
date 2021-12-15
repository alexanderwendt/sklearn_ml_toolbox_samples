#!/bin/bash

###
# Functions
###

setup_env()
{
  # Environment preparation
  echo Activate environment
  #call conda activate %PYTHONENV%
  . ./init_env.sh

  echo Activate task spooler
  . ./init_ts.sh

}

get_config_name()
{
  MYFILENAME=`basename "$0"`
  CONFIG=`echo $MYFILENAME | sed 's/is23X_complete_datapreparation_//' | sed 's/.sh//'`
  echo Selected model: $CONFIG
}

###
# Main body of script starts here
###

echo #==============================================#
echo # SKLearn ML Toolbox
echo #==============================================#

# Constant Definition
SCRIPTPREFIX=../../sklearn_ml_toolbox

#Extract model name from this filename
get_config_name

#Setup environment
setup_env

echo Apply config $CONFIG.ini

echo ===========================================
echo  Generate Dataset #
echo ===========================================
#rem python step20_generate_groundtruth_stockmarket.py --config_path=%config_file%
python $SCRIPTPREFIX/step21_generate_features.py --config_path=./config/$CONFIG.ini -debug
python $SCRIPTPREFIX/step22_adapt_dimensions.py --config_path=./config/$CONFIG.ini

echo ===========================================
echo  Data Analysis and Preprocessing 
echo ===========================================
python $SCRIPTPREFIX/step30_clean_raw_data.py --config_path=./config/$CONFIG.ini --no_images --on_inference_data
python $SCRIPTPREFIX/step31_adapt_features.py --config_path=./config/$CONFIG.ini
# python %script_prefix%\step32_search_hyperparameters.py --config_path=%config_file%
# python %script_prefix%\step33_analyze_data.py --config_path=%config_file%
# python %script_prefix%\step34_analyze_temporal_data.py --config_path=%config_file%
# python %script_prefix%\step35_perform_feature_selection.py --config_path=%config_file%
# python %script_prefix%\step36_split_training_validation.py --config_path=%config_file%


echo ===========================================
echo  Model Training 
echo ===========================================


echo =================================================
echo  Training Model for Temporal Datasets 
echo =================================================


echo =================================================
echo  Model Evaluation for Temporal Datasets 
echo =================================================


echo =================================================
echo  Post Processing 
echo =================================================



echo Training and Inference finished.
