#!/bin/bash

#############################
### This porgram is for interpolate model data from ICON/COSMO/GME to
### regular lon lat grid defined by the user
### 
### The script need the following programs:
### cdo, nco (CDE,CEU)
###
### Usage: 
### ./cdo_interpolation_meso.sh
###
#############################

##############
# Section 1: 
# User Setting
##############
    
# if script using on mistral
 l_mistral=1
   
# output directory
# dir_out='/work/bm0982/b380388/icon_postproc/icon_interpolated/test'
 dir_out='/automount/cluma06/hdcp2/s6stpoll/interpolated'
 add_name_out='merge_test'
 
# model choice
# only one model per execution
l_les156=0
l_les312=0
l_les624=0
l_cde=0
l_ceu=1
l_gme=0
l_echam_tamip=0  # not completely implemented until now, hrsta and hrend should be the same. all timesteps are proceed in one step
l_icon_tamip=0   # not completely implemented until now, hrsta and hrend should be the same. all timesteps are proceed in one step

# for interpolatng the grid (=1) or external data
# hrsta and hrend should be the same , only one datev (does not matter which day!)
l_grid=0
l_external=0
 
# choose time and date 
#datev=('20130420 20130424 20130425 20130426 20130502 20130505 20130511 20130528')
datev=('20130424')
hrsta=0
hrend=22
hrinc=2

# choose area
# set new areas at section 2
# predefined areas=('juelich' 'cabauw' 'lindenberg' 'melpitz' 'dedomain' 'nrw_downscale')
area=('nrw_downscale')

# postprocess for ICON output data (only affect for surf2d, cloud2d, rad2d)
# "" for no addiational postprocess
# "-yhouravg" for hourly averaged values
# "-seltimestep,1" for extracting first time step only
  les_postproc="-seltimestep,1"

#  choose variables for ICON
  var_rest2d='tot_prec,tot_qv_dia,tsfctrad,tcm,tch,gz0,ddt_temp_radsw,ddt_temp_radlw'
  var_rest3d=''
#  var_rest3d='vn.TL1,w.TL1,rho.TL1,theta_v.TL1,qv.TL1,exner.TL1,vt,ddt_vn_phy,ddt_exner_phy,ddt_w_adv.TL1'
  var_surf2d='tsl,t_s,tcm,tch'
  var_cloud2d='clt,z_pbl,rain_gsp_rate,clch,clcm,clcl'
  var_rad2d=''

# if choosen icon restart files, please choose level. 1/151 for all levels
 lay_rest3d='80/151'

# path to COSMO/GME data
  dir_cosmo='/automount/cluma06/hdcp2/analyses/'
# choose variables for COSMO
  mvar="T_GDS10_HYBY_13,U_GDS10_HYBY_13,V_GDS10_HYBY_13,VERT_VEL_GDS10_HYBL_13,QV_GDS10_HYBY_13,PS_GDS10_GPML_13,LAI_GDS10_SFC_13,GEOMET_H_GDS10_HYBL_13,T_GDS10_HYBY_13,PS_GDS10_HYBY_13,ASHFL_S_GDS10_SFC_13,ALHFL_S_GDS10_SFC_13,GEOMET_H_GDS10_SFC_13,CLCT_GDS10_SFC_13,CLCL_GDS10_SFC_13,ASOB_S_GDS10_SFC_13,ATHB_S_GDS10_SFC_13,ALB_RAD_GDS10_SFC_13"

# interpolation method (only nn for neighrest neighbor and dw for distance weihtening
 s_interp='nn'

# choose definition of grid spacing. This change the definition of "ICON-resolution". For the definition see e.g. "Using and programming ICON - a first introduction" - Rast
# l_def = 1 for lon-lat grid representing same area, l_def = 2 for lon-lat grid have same grid spacing as ICON 
# this switch make a difference in the number of grid points in lon-lat of 9/4 or 4/9
# grid spacings optimised for lat=51
l_def=1

##############
# Section 2: 
# Start of the program
# *** EXPERIENCED USER ***
##############

 if [[ $l_mistral == 1 ]]; then
  # module load cdo/1.7.0-magicsxx-gcc48
   module load nco/4.5.0-gcc48
 fi


for date in ${datev[@]}
 do

 echo '########################################'
 echo '######'$date'##########'
 echo '########################################'

# make directory if not exits
if [ ! -d $dir_out'/'$date ]; then
  mkdir $dir_out'/'$date 
fi



for iarea in ${area[@]}
 do

 echo 'AREA OF INVESTIGATION:  '$iarea

  if [ "$iarea" == "juelich" ]; then

   # juelich
   lonsta=5.1 # lon start
   latsta=50.0 # lat start
   lonend=7.7 # lon end
   latend=51.8 # lat end
   domain_name='juelich'

   fi # 

  if [ "$iarea" == "cabauw" ]; then

#  cabauw
 lonsta=4.6 # lon start shifted from 3.6
 latsta=51.1 # lat start
 lonend=7.2  # lon end shifted from 6.2
 latend=52.9 # lat end
 domain_name='cabauw'

  fi # cabauw


  if [ "$iarea" == "lindenberg" ]; then

#  lindenberg
 lonsta=11.9 # 12.8 # lon start
 latsta=51.3 # lat start
 lonend=14.5 # 15.4 # lon end
 latend=53.1 # lat end
 domain_name='lindenberg'

 fi # lindenberg


 if [ "$iarea" == "melpitz" ]; then
 # melpitz
 lonsta=11.6 # lon start
 latsta=50.6 # lat start
 lonend=14.2 # lon end
 latend=52.4 # lat end
 domain_name='melpitz'
 fi # melpitz


 if [ "$iarea" == "dedomain" ]; then
 lonsta=4.5 # lon start
 latsta=47.6 # lat start
 lonend=14.5 # lon start
 latend=54.6 # lat start
 domain_name=$iarea
 fi # 

 if [ "$iarea" == "nrw_downscale" ]; then
 lonsta=5.6 # lon start
 latsta=50.2 # lat start
 lonend=7.3 # lon start
 latend=51.3 # lat start
 domain_name="$iarea"
 fi # 



##############
#  Loop over hours
##############

for ihr in $(seq ${hrsta} ${hrinc} ${hrend})
  do

  if [ $ihr -lt 10 ]
    then hr='0'${ihr}
    else hr=${ihr}
  fi

##############
#  Model choice
##############


###
# ICON LES Restart from M-project 
###


if [[ $l_les156 == 1 ]]; then

   if [ "$date" == "20130424" ] || [ "$date" == "20130425" ]||[ "$date" == "20130426" ]; then
    path_restart='/work/bm0834/k203095/OUTPUT/'$date'-default/RESTART-DOM03'
   else
    path_restart='/work/bm0834/k203095/OUTPUT/'$date'-default/RESTART'
   fi

    path_defout='/work/bm0834/k203095/OUTPUT/'$date'-default/DATA'
#    fname_grid=$path_restart'/../../GRIDS/GRID_default_3d_fine_DOM03_ML.nc'
    fname_grid="/work/bm0834/k203095/OUTPUT/20130420-default/RESTART/hdcp2_cosmodom_nest_R0156m.nc"


 # model output (interpolated)
    path_out=$dir_out'/'$date
    pmodel_out='icon_156m'
     
    if [[ $l_grid == 1 ]]; then
      fname='/../GRIDS/GRID_default_3d_fine_DOM03_ML.nc'
      fname_out=$pmodel_out'_merged_'$domain_name'_grid.nc'
      else
      fname_restart='hdcp2_cosmodom_nest_R0156m_restart_atm_'$date'T'$hr'0000Z.nc'

      if [ $ihr -ge  6 ]; then
        fname_2dsurf='2d_surface_day_DOM03_ML_'$date'T'$hr'0000Z.nc'
        fname_2dcloud='2d_cloud_day_DOM03_ML_'$date'T'$hr'0000Z.nc'
        fname_2drad='2d_rad_day_DOM03_ML_'$date'T'$hr'0000Z.nc'
      else
        fname_2dsurf='2d_surface_night_DOM03_ML_'$date'T'$hr'0000Z.nc'
        fname_2dcloud='2d_cloud_night_DOM03_ML_'$date'T'$hr'0000Z.nc'
        fname_2drad='2d_rad_night_DOM03_ML_'$date'T'$hr'0000Z.nc'
      fi

      fname_out=$pmodel_out'_'$add_name_out'_'$date$hr'00_'$domain_name'.nc'
    fi

    path_external='/work/bm0834/k203095/pool/HDCP2_FINAL_INPUT_4'
    fname_external='extpar_hdcp2_cosmodom_nest_R0156m.nc'
    fname_out_ext=$pmodel_out'_external_'$domain_name'.nc'
       
    # mesh size
    if [[ $l_def == 1 ]]; then
      xinc=0.0022 #156m
      yinc=0.0014 #156m
    else
      xinc=0.0015 #156m
      yinc=0.0009 #156m
    fi 

fi


if [[ $l_les312 == 1 ]]; then

   if [ "$date" == "20130424" ] || [ "$date" == "20130425" ]||[ "$date" == "20130426" ]; then
    path_restart='/work/bm0834/k203095/OUTPUT/'$date'-default/RESTART-DOM03'
   else
    path_restart='/work/bm0834/k203095/OUTPUT/'$date'-default/RESTART'
   fi

    path_defout='/work/bm0834/k203095/OUTPUT/'$date'-default/DATA'
    fname_grid="/work/bm0834/k203095/OUTPUT/20130420-default/RESTART/hdcp2_cosmodom_nest_R0312m.nc"

 # model output (interpolated)
    path_out=$dir_out'/'$date
    pmodel_out='icon_312m'

    if [[ $l_grid == 1 ]]; then
      fname='../GRIDS/GRID_default_3d_fine_DOM02_ML.nc'
      fname_out=$pmodel_out'_merged_'$domain_name'_grid.nc'
      else
      fname_restart='hdcp2_cosmodom_nest_R0312m_restart_atm_'$date'T'$hr'0000Z.nc'

      if [ $ihr -ge  6 ]; then
        fname_2dsurf='2d_surface_day_DOM02_ML_'$date'T'$hr'0000Z.nc'
        fname_2dcloud='2d_cloud_day_DOM02_ML_'$date'T'$hr'0000Z.nc'
        fname_2drad='2d_rad_day_DOM02_ML_'$date'T'$hr'0000Z.nc'
      else
        fname_2dsurf='2d_surface_night_DOM02_ML_'$date'T'$hr'0000Z.nc'
        fname_2dcloud='2d_cloud_night_DOM02_ML_'$date'T'$hr'0000Z.nc'
        fname_2drad='2d_rad_night_DOM02_ML_'$date'T'$hr'0000Z.nc'
      fi
      fname_out=$pmodel_out'_'$add_name_out'_'$date$hr'00_'$domain_name'.nc'
    fi

    path_external='/work/bm0834/k203095/pool/HDCP2_FINAL_INPUT_4'
    fname_external='extpar_hdcp2_cosmodom_nest_R0312m.nc'
    fname_out_ext=$pmodel_out'_external_'$domain_name'.nc'

    # mesh size
    if [[ $l_def == 1 ]]; then 
      xinc=0.0045 #312m
      yinc=0.0028 #312m
    else
      xinc=0.0030 #312m
      yinc=0.0019 #312m
    fi

fi


if [[ $l_les624 == 1 ]]; then

   if [ "$date" == "20130424" ] || [ "$date" == "20130425" ]||[ "$date" == "20130426" ]; then
    path_restart='/work/bm0834/k203095/OUTPUT/'$date'-default/RESTART-DOM03'
   else 
    path_restart='/work/bm0834/k203095/OUTPUT/'$date'-default/RESTART'
   fi
    path_defout='/work/bm0834/k203095/OUTPUT/'$date'-default/DATA' 
    fname_grid="/work/bm0834/k203095/OUTPUT/20130420-default/RESTART/hdcp2_cosmodom_R0625m.nc"

 # model output (interpolated)
    path_out=$dir_out'/'$date
    pmodel_out='icon_624m'   

    if [[ $l_grid == 1 ]]; then
      fname='../GRIDS/GRID_default_3d_fine_DOM01_ML.nc'
      fname_out=$pmodel_out'_merged_'$domain_name'_grid_test.nc'
      else 
      fname_restart='hdcp2_cosmodom_R0625m_restart_atm_'$date'T'$hr'0000Z.nc'
      if [ $ihr -ge  6 ]; then 
        fname_2dsurf='2d_surface_day_DOM01_ML_'$date'T'$hr'0000Z.nc'
        fname_2dcloud='2d_cloud_day_DOM01_ML_'$date'T'$hr'0000Z.nc'
        fname_2drad='2d_rad_day_DOM01_ML_'$date'T'$hr'0000Z.nc'
      else
        fname_2dsurf='2d_surface_night_DOM01_ML_'$date'T'$hr'0000Z.nc'
        fname_2dcloud='2d_cloud_night_DOM01_ML_'$date'T'$hr'0000Z.nc'
        fname_2drad='2d_rad_night_DOM01_ML_'$date'T'$hr'0000Z.nc'
      fi
      fname_out=$pmodel_out'_'$add_name_out'_'$date$hr'00_'$domain_name'.nc'  
    fi

    path_external='/work/bm0834/k203095/pool/HDCP2_FINAL_INPUT_4'
    fname_external='extpar_hdcp2_cosmodom_R0625m.nc'
    fname_out_ext=$pmodel_out'_external_'$domain_name'_test.nc'
    
    # mesh size
    if [[ $l_def == 1 ]]; then
      xinc=0.0089 #624m
      yinc=0.0056 #624m
    else
      xinc=0.0059 #624m
      yinc=0.0038 #624m
    fi
    
fi  


if [[ $l_cde == 1 ]]; then

    # model input
    pmodel='cde'
    fname='laf'$date$hr

    # model output (interpolated)
    pmodel_out='cde_2800m'
    path_out=$dir_out'/'$date
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_'$ext_name'.nc'

    # mesh size (native resolution)
    xinc=0.025 #2800m
    yinc=0.025 #2800m    
fi

if [[ $l_ceu == 1 ]]; then

    # model input
    pmodel='ceu'
    fname='laf'$date$hr

    # model output (interpolated)
    pmodel_out='ceu_7000m'
    path_out=$dir_out'/'$date
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_'$ext_name'.nc'

    # mesh size (native resolution)
    xinc=0.0625 #7000m
    yinc=0.0625 #7000m
fi


if [[ $l_gme == 1 ]]; then
    # model input
    pmodel='gme'
#    fname='gaf'$date$hr # depend on which data were downloaded
    fname='giff'$date$hr
#    fname='invar.i384a.2012022900' # to extract external files

    # model output (interpolated)
    pmodel_out='gme_20000m'
    path_out=$dir_out'/'$date
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_'$ext_name''

    # mesh size
    if [[ $l_def == 1 ]]; then
      xinc=0.6410 #20000m 
      yinc=0.4045 #20000m 
    else  
     xinc=0.2838 #20000m 
     yinc=0.1797 #20000m 
    fi

fi


if [[ $l_echam_tamip == 1 ]]; then

    path_defout='/work/bm0834/HDCP2_TAMIP/ECHAM/trc0101/trc0101.'$date

    path_out=$dir_out'/'$date
    pmodel_out='echam_40000m'

    fname_out=$pmodel_out'_2dvar_'$date$hr'00_'$domain_name'.nc'

    # mesh size
    xinc=0.95 #40000m 
    yinc=0.95 #40000m

fi

if [[ $l_icon_tamip == 1 ]]; then

    path_defout='/work/bm0834/HDCP2_TAMIP/ICON_NWP/'$date

    path_out=$dir_out'/'$date
    pmodel_out='icon_40000m'

    fname_out=$pmodel_out'_2dvar_'$date$hr'00_'$domain_name'.nc'

     # mesh size
    if [[ $l_def == 1 ]]; then
      xinc=1.28 #40000m 
      yinc=0.80 #40000m
    else
      xinc=0.57 #40000m 
      yinc=0.36 #40000m 
    fi

fi

 echo "Processing : " $pmodel 

##############
# Section 3: 
# Preparation of namelist for cdo-interpolation
# Calculate grid size and prepare grid information
# Do not change behind this line
##############

 xfirst=$lonsta
 yfirst=$latsta
 
 xsize=$(echo "scale=0;($lonend-$lonsta)/$xinc" | bc)
 ysize=$(echo "scale=0;($latend-$latsta)/$yinc" | bc)
 
 gridsize=$(echo "$xsize*$ysize" | bc)

 grid_file=$path_out/targetgrid.txt
 
 echo $grid_file
 
 rm $grid_file

# write grid-file for cdo command
cat > $grid_file << EOF
gridtype   = lonlat
gridsize   = $gridsize
xname      = lon
xlongname  = longitude
xunits     = degrees_east
yname      = lat
ylongname  = latitude
yunits     = degrees_north
xsize      = $xsize
ysize      = $ysize
xfirst     = $xfirst
xinc       = $xinc
yfirst     = $yfirst
yinc       = $yinc
EOF


##############
# Section 4: 
# Interpolation
##############

if [ "$s_interp" == "nn" ]; then
  interpm="nn"
elif [ "$s_interp" == "dw" ]; then
  interpm="dis"
else
  echo "choose interpolation method"
fi


if [ $l_grid == 0 ] && [ $l_external == 0 ]; then

if [ $l_echam_tamip == "1" ];then

#cdo -O -f nc copy -sellonlatbox,5.,12.,47.,55.  ATM_trc0101.20130424_20130429 ATM_trc0101.20130424_20130429_test.nc
#   cdo -O -f nc copy -sellonlatbox,$lonsta,$lonend,$latsta,$latend $path_defout"/BOT_trc0101."$date'_20130429' $path_out'/'$fname_out
   cdo -O -f nc copy -sellonlatbox,$lonsta,$lonend,$latsta,$latend $path_defout"/BOT_trc0101."$date'_20130429' $path_out'/'$fname_out
#ATM_trc0101.20130424_20130429 ATM_trc0101.20130424_20130429_test.nc
#BOT_trc0101.20130424_20130429  

  module load nco

  ncrename -v var176,sob $path_out'/'$fname_out
  ncrename -v var177,thb $path_out'/'$fname_out
#  ncrename -v var121,shf_over_land $path_out'/'$fname_out
  ncrename -v var146,shf $path_out'/'$fname_out
  ncrename -v var147,lhf $path_out'/'$fname_out
  
  ncrename -v var164,clt $path_out'/'$fname_out
  ncrename -v var34,cll $path_out'/'$fname_out
  ncrename -v var76,rhf $path_out'/'$fname_out
  ncrename -v var200,lai $path_out'/'$fname_out
  ncrename -v var173,z0 $path_out'/'$fname_out

fi

if [ $l_icon_tamip == "1" ];then

 cdo -O remap$interpm,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend $path_defout"/BOT_R02B06_"$date'00_DOM01_ML_0001.nc' $path_out'/'$fname_out

fi

if [ "$l_les156" == "1" ] || [ "$l_les312" == "1" ]||[ "$l_les624" == "1" ]; then

  # ncatted -O -h -a history,global,d,, $path_defout"/"$fname_2drad $path_defout"/"$fname_2drad    

  # delete unessesary file
  rm $path_out'/restart_2d_reglonlat.nc'
  rm $path_out'/restart_3d_reglonlat.nc'
  rm $path_out'/2dsurf_reglonlat.nc'
  rm $path_out'/2dcloud_reglonlat.nc'
  rm $path_out'/2drad_reglonlat.nc'
  merging_files=''

 
 if [ ! -f  $path_out'/../'$pmodel_out'_weights3d_'$domain_name'_'$s_interp'.nc' ] && [ ! $var_rest3d == '' ]; then
   rm $path_out'/3dweightsprep.nc'
   echo "calculate 3d weights"
  echo "cdo -O -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rest3d -sellevidx,$lay_rest3d $path_restart"/"$fname_restart $path_out'/3dweightsprep.nc'" 
  cdo -O -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rest3d -sellevidx,$lay_rest3d $path_restart"/"$fname_restart $path_out'/3dweightsprep.nc'
#  cdo -P 24 gennn,$grid_file $path_out'/3dweightsprep.nc'  $path_out'/../'$pmodel_out'_weights3d_'$domain_name'_'$s_interp'.nc'
  cdo -P 24 gen$interpm,$grid_file $path_out'/3dweightsprep.nc'  $path_out'/../'$pmodel_out'_weights3d_'$domain_name'_'$s_interp'.nc'
  rm $path_out'/3dweightsprep.nc'
 fi 

 if [ ! -f  $path_out'/../'$pmodel_out'_weights2d_'$domain_name'_'$s_interp'.nc' ]; then
   rm $path_out'/2dweightsprep.nc'
   echo "calculate 2d weights"
   cdo -O -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_surf2d -seltimestep,1 $path_defout"/"$fname_2dsurf $path_out'/2dweightsprep.nc' 
   cdo -P 24 gen$interpm,$grid_file $path_out'/2dweightsprep.nc'  $path_out'/../'$pmodel_out'_weights2d_'$domain_name'_'$s_interp'.nc'
   rm $path_out'/2dweightsprep.nc'
 fi

 if [ ! $var_rest2d == '' ];then
 echo "interpoalte 2D restart"
  cdo -O -P 24 remap,$grid_file,$path_out'/../'$pmodel_out'_weights2d_'$domain_name'_'$s_interp'.nc' -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rest2d -selltype,1 $path_restart"/"$fname_restart $path_out'/restart_2d_reglonlat.nc'
   ## cdo -O remap,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rest2d -selltype,1 $path_restart"/"$fname_restart $path_out'/restart_2d_reglonlat.nc'
    merging_files=$merging_files' '$path_out'/restart_2d_reglonlat.nc'
 fi

 if [ ! $var_rest3d == '' ];then
 echo "interpolate 3D restart"
  cdo -O -P 24 remap,$grid_file,$path_out'/../'$pmodel_out'_weights3d_'$domain_name'_'$s_interp'.nc' -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rest3d -sellevidx,$lay_rest3d $path_restart"/"$fname_restart $path_out'/restart_3d_reglonlat.nc'
## cdo -O remap,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rest3d -sellevidx,$lay_rest3d $path_restart"/"$fname_restart $path_out'/restart_3d_reglonlat.nc'
    merging_files=$merging_files' '$path_out'/restart_3d_reglonlat.nc'
 fi

 if [ ! $var_surf2d == '' ];then
  echo "interpolate 2D surface"
  cdo -O -P 24 remap,$grid_file,$path_out'/../'$pmodel_out'_weights2d_'$domain_name'_'$s_interp'.nc' -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_surf2d  $les_postproc $path_defout"/"$fname_2dsurf $path_out'/2dsurf_reglonlat.nc'
  merging_files=$merging_files' '$path_out'/2dsurf_reglonlat.nc'
 fi

 if [ ! $var_cloud2d == '' ];then
   echo "interpolate 2d Cloud"
   cdo -O -P 24 remap,$grid_file,$path_out'/../'$pmodel_out'_weights2d_'$domain_name'_'$s_interp'.nc' -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_cloud2d $les_postproc $path_defout"/"$fname_2dcloud $path_out'/2dcloud_reglonlat.nc'
 fi

 if [ ! $var_rad2d == '' ];then
 echo "interpolate 2D Radiation"
   cdo -O -P 24 remap,$grid_file,$path_out'/../'$pmodel_out'_weights2d_'$domain_name'_'$s_interp'.nc' -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rad2d $les_postproc $path_defout"/"$fname_2drad $path_out'/2drad_reglonlat.nc'
   merging_files=$merging_files' '$path_out'/2drad_reglonlat.nc'
 fi

  echo "merge data"
  cdo -O -P 24 merge $merging_files $path_out'/'$fname_out

  # delete unessesary file
  rm $path_out'/restart_2d_reglonlat.nc'
  rm $path_out'/restart_3d_reglonlat.nc'
  rm $path_out'/2dsurf_reglonlat.nc'
  rm $path_out'/2dcloud_reglonlat.nc'
  rm $path_out'/2drad_reglonlat.nc'


fi # if model

fi # if  grid

if [[ $l_grid == 1 ]]; then

  cdo -O remap$interpm,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -sellevidx,80/151 $path_restart"/"$fname $path_out'/'$fname_out
#  cdo -O sellonlatbox,$lonsta,$lonend,$latsta,$latend -selname,ifs2icon_cell_grid,ifs2icon_edge_grid,ifs2icon_vertex_grid,lon_cell_centre,lat_cell_centre $fname_grid $path_out'/'$fname_out

fi # if  grid


if [[ $l_external == 1 ]]; then
   cdo -O remap$interpm,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid $path_external'/'$fname_external $path_out'/'$fname_out_ext
fi # if  external



if [ $l_cde == 1 ] || [ $l_ceu == 1 ]; then

    ncl_convert2nc $dir_cosmo"/"$pmodel"/"${fname}".grb" -B
    mv ${fname}".nc" ${path_out}
 
  # select variables because some variables causes error in the transformation    
     echo "cdo select"
     cdo select,name=$mvar $path_out"/"$fname".nc" $path_out"/temporary_int2reg_file.nc"
     ncatted -a coordinates,VERT_VEL_GDS10_HYBL_13,c,c,"g10_lon_1 g10_lat_0"  $path_out"/temporary_int2reg_file.nc"
 
     # interpolation
     echo "cdo remap$interpm,$grid_file $path_out"/temporary_int2reg_file.nc" $path_out"/"$fname_out"
     cdo remap$interpm,$grid_file $path_out"/temporary_int2reg_file.nc" $path_out"/"$fname_out
     
     # delete unessesary file
     rm $path_out"/temporary_int2reg_file.nc"
     rm $path_out"/"$fname".nc"
fi


 if [[ $l_gme == 1 ]]; then
     
     # interpolation
     echo "cdo remap$interpm,$grid_file $dir_cosmo"/"$pmodel"/"$fname $path_out"/"$fname_out"
     cdo remap$interpm,$grid_file $path"/"$pmodel"/"$fname $path_out"/"$fname_out".grb"
     
     # convert to netcdf
     ncl_convert2nc ${path_out}"/"${fname_out}".grb" -B
     mv ${fname_out}".nc" ${path_out}
     rm ${path_out}"/"${fname_out}".grb"
 fi


 done # for loop

done # for area

done # for date
