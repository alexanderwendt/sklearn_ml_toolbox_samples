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
  CONFIG=`echo $MYFILENAME | sed 's/ts4567X_complete_training_//' | sed 's/.sh//'`
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


echo ===========================================#
echo  Model Training #
echo ===========================================#
python $SCRIPTPREFIX/step42_analyze_training_time.py --config_path=./config/$CONFIG.ini
python $SCRIPTPREFIX/step43_wide_hyperparameter_search_all.py --config_path=./config/$CONFIG.ini --execute_wide=True -debug
#python $SCRIPTPREFIX/step43_wide_hyperparameter_search_all.py --config_path=./config/$CONFIG.ini --execute_wide=True
python $SCRIPTPREFIX/step44_narrow_hyperparameter_search_all.py --config_path=./config/$CONFIG.ini
python $SCRIPTPREFIX/step45_define_precision_recall.py --config_path=./config/$CONFIG.ini

echo =================================================#
echo  Training Model for Temporal Datasets #
echo =================================================#
python $SCRIPTPREFIX/step50_train_model_from_pipe.py --config_path=./config/$CONFIG.ini --config_section="ModelTrain"
# train the final model
python $SCRIPTPREFIX/step50_train_model_from_pipe.py --config_path=./config/$CONFIG.ini --config_section="ModelFinal"

echo =================================================#
echo  Model Evaluation for Temporal Datasets #
echo =================================================#
python $SCRIPTPREFIX/step60_evaluate_model.py --config_path=./config/$CONFIG.ini --config_section="EvaluationTraining"
python $SCRIPTPREFIX/step61_evaluate_model_temporal_data.py --config_path=./config/$CONFIG.ini --config_section="EvaluationTraining"

python $SCRIPTPREFIX/step60_evaluate_model.py --config_path=./config/$CONFIG.ini --config_section="EvaluationValidation"
python $SCRIPTPREFIX/step61_evaluate_model_temporal_data.py --config_path=./config/$CONFIG.ini --config_section="EvaluationValidation"


echo =================================================#
echo  Post Processing #
echo =================================================#
python $SCRIPTPREFIX/step71_value_postprocessing.py --config_path=./config/$CONFIG.ini --config_section="EvaluationValidation"
python $SCRIPTPREFIX/step72_backtesting.py --config_path=./config/$CONFIG.ini --config_section="EvaluationValidation"


echo Training and Inference finished.
