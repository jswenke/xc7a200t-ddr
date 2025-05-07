#project make script

SOURCE="${BASH_SOURCE[0]}"
SCRIPT_DIR="$(cd -P "$( dirname "$SOURCE")" && pwd )"
PROJECT_DIR="$( realpath $SCRIPT_DIR/../project )"


echo "Use default XILINX_VIVADO location @ /tools/Xilinx/Vivado?"
echo "1. Yes
2. No
Enter (1/2)..."
read vivado_location_prompt


if [ $vivado_location_prompt -eq 1 ]; then
	echo ""
	echo "Running env.sh..."
	source $SCRIPT_DIR/build_script_dependencies/env.sh
	source $XILINX_VIVADO/settings64.sh
fi


if [ ! $(command -v vivado >/dev/null 2>&1)]; then
	echo "Trying to use \$XILINX_VIVADO=$XILINX_VIVADO"

	if [ -z $XILINX_VIVADO ]; then
		echo "The XILINX_VIVADO variable has not been set"

		if [ ! -e $XILINX_VIVADO/bin/vivado ]; then
			echo "Couldn't find a candidate for Vivado installation"
			echo "Edit build_script_depdendencies/env.sh to include correct Vivado path on this system"
			exit 1
		fi
		echo "Using $XILINX_VIVADO..."
	else
		echo "Found Vivado at $XILINX_VIVADO"
	fi
fi


echo ""
echo "-------------------- AMP build script --------------------"
echo "Build/make/update options:"
echo "1. Make project (performs all project config prior needed prior to synth)"
echo ""
echo "The following options are NOT yet implemented:"
echo "2. Update BD script (used after making changes in BD GUI, address map, etc."
echo "3. Update IP .xci's"
echo "4. Update all IP/BD/misc."
echo ""
echo "Enter (1)..."
echo "----------------------------------------------------------"
read buildmode
export TCL_BUILD_MODE=$buildmode


$XILINX_VIVADO/bin/vivado -mode batch -source $SCRIPT_DIR/build_script_dependencies/make_project.tcl

# Comment these out if you want the log/journal files Vivado generates
rm $SCRIPT_DIR/*.jou 2> /dev/null
rm $SCRIPT_DIR/*.log 2> /dev/null
rm $SCRIPT_DIR/../*.jou 2> /dev/null
rm $SCRIPT_DIR/../*.log 2> /dev/null


		

