#make project script

set scriptsDir [file normalize [file dirname [info script]]/..]
set projectDir [file normalize $scriptsDir/../project]


file mkdir $projectDir
cd $projectDir
source $scriptsDir/build_script_dependencies/config_project.tcl
set buildMode $env(TCL_BUILD_MODE)


if {$buildMode eq 1} {
	createVivadoProject
	addProjectIPandHDL
	addConstraints
} elseif {$buildMode eq 2} {
	puts "Error: Select build option 1, others not implemented yet"
} elseif {$buildMode eq 3} {
	puts "Error: Select build option 1, others not implemented yet"
} elseif {$buildMode eq 4} {
	puts "Error: Select build option 1, others not implemented yet"
} else {
	puts "Error: Select build option 1, others not implemented yet"
}	

