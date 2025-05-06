# config project parameters, hierarchy, constraints, etc.

set PROJECT_NAME amp
set PART_TYPE xc7a200tfbg484-2

set scriptsDir	[file normalize [file dirname [info script]]/..]
set repoRootDir	[file normalize $scriptsDir/..]
set projectDir	[file normalize $repoRootDir/project]
set rtlDir	[file normalize $repoRootDir/source/rtl]
set ipDir	[file normalize $repoRootDir/source/ip]
set bdDir	[file normalize $repoRootDir/source/bd]
set constrsDir	[file normalize $repoRootDir/constraints]
set simDir	[file normalize $repoRootDir/sim]


proc createVivadoProject {} {

	global PROJECT_NAME 
	global PART_TYPE

	create_project -part $PART_TYPE -force $PROJECT_NAME
	set_property target_language VHDL [current_project]
	set_property top ${PROJECT_NAME}_top [current_fileset]
	#config_webtalk -user off
	#
}


proc addProjectIPandHDL {} {

	global PROJECT_NAME
	global PART_TYPE

	global projectDir
	global rtlDir
	global ipDir
	global simDir

	read_vhdl $rtlDir/amp_top.vhd
	set_property top amp_top [current_fileset]
	read_vhdl -library amp_lib $rtlDir/amp_pkg.vhd

	##EXAMPLE add files to libs
	#set ampLibFilesVHD [concat \
	#	[glob -nocomplain $rtlDir/amp_main/*.vhd] \
	#	[glob -nocomplain $rtlDir/amp_main/*/*.vhd]]
	#set ampLibFilesSV  [concat \
	#	[glob -nocomplain $rtlDir/amp_main/*.sv] \
	#	[glob -nocomplain $rtlDir/amp_main/*/*.sv]]
	#
	#read_vhdl -library amp_lib $ampLibFilesVHD
	#read_verilog -library amp_lib $ampLibFilesSV
	
	##EXAMPLE set VHDL2008
	#set_property file_type {VHDL 2008} [get_files [glob -nocomplain $rtlDir/*.vhd]] -quiet
	
	create_fileset -simset amp_sim
	file mkdir $projectDir/${PROJECT_NAME}.sim/amp_sim
	add_files -fileset amp_sim -norecurse [glob -nocomplain $simDir/testbenches/*.vhd] -quiet
	set_property top tb_amp_top [get_filesets amp_sim]
	#
	current_fileset -simset amp_sim
	#delete_fileset sim_1 -quiet
	
	#ADDING .XCI'S/.XCIX'S
	import_ip [glob -nocomplain $ipDir/xci/*/*.xci] -quiet
	import_ip [glob -nocomplain $ipDir/xcix/*/*.xcix] -quiet

}	


proc genBlockDesign {} {

	source $bdDir/system.tcl

}


proc addConstraints {} {

	global PROJECT_NAME

	global projectDir
	global constrsDir

	create_fileset -constrset constrs_ampboard
	file mkdir $projectDir/${PROJECT_NAME}.srcs/constrs_ampboard
	#add_files -fileset constrs_ampboard $constrsDir/constrs_ampboard/amp_constrs_top.xdc

	#set_property target_constrs_file $constrsDir amp_constrs_top [get_filesets constrs_ampboard]
}
