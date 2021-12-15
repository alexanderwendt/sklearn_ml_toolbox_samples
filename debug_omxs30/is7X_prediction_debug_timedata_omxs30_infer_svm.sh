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
  CONFIG=`echo $MYFILENAME | sed 's/is7X_prediction_//' | sed 's/.sh//'`
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



echo ===========================================#
echo  Generate Dataset #
echo ===========================================#


echo ===========================================#
echo  Data Analysis and Preprocessing #
echo ===========================================#


echo =================================================#
echo  Model Training#
echo =================================================#


echo =================================================#
echo  Model Evaluation for Temporal Datasets #
echo =================================================#


echo =================================================#
echo  Prediction #
echo =================================================#
python $SCRIPTPREFIX/step70_predict_temporal_data.py --config_path=./config/$CONFIG.ini --config_section="EvaluationInference"