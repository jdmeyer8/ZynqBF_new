# Add the files
set project_files [list \
  "${adi_prj_dir}/${boardName}/system_constr.xdc" \
  "${ad_hdl_dir}/library/xilinx/common/ad_iobuf.v" ]

add_files -norecurse -fileset sources_1 $project_files

# Set the script to be sourced
set system_bd_script ${ad_hdl_dir}/projects/fmcomms5/zcu102/system_bd.tcl
set IP_AXIM 4
set MW_GPIO_WIDTH 96