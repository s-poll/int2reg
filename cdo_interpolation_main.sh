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
    
# location
# juelich
 lonsta=4.5 #5.1 # lon start
 latsta=47.6 #50.0 # lat start
 lonend=14.5 #7.7 # lon end
 latend=54.6 # lat end

# model choice
# only one model per execution
l_les156=0
l_les312=0
l_les624=0
l_cde=0
l_ceu=1
l_gme=0

# path of data and output
 path='/automount/cluma06/hdcp2/analyses/'
 path_out='/automount/user/pshrestha/'

# for icon LAI_GDS10_SFC_13 (special lai for gme)
l_mistral=0 # if running script on mistral
l_les_lai=0
l_grid=0 
 
 
# 
domain_name='GERMANY'
ext_name='rad2deg'

# time 
#(if ncl_convert2nc does not work, you have start the script for each time step)
date='20130424' # yyyymmdd
hrsta=0 
hrend=24
hrinc=1 # increament
 
##############
# Section 2: 
# Model choice
# *** EXPERIENCED USER ***
##############
# 

# loop over hours (do not change)
for ihr in $(seq ${hrsta} ${hrinc} ${hrend})
  do


  if [ $ihr -lt 10 ]
    then hr='0'${ihr}
    else hr=${ihr}
  fi

  
####
# ICON LES
####


if [[ $l_les156 == 1 ]]; then
    path_restart='/work/bm0834/k203095/OUTPUT/'$date'-default/RESTART-DOM03'
    path_defout='/work/bm0834/k203095/OUTPUT/'$date'-default/DATA'
    fname_grid="/work/bm0834/k203095/OUTPUT/20130420-default/RESTART/hdcp2_cosmodom_nest_R0156m.nc"
 #   fname_grid=$path_restart'/../../GRIDS/GRID_default_3d_fine_DOM03_ML.nc'

 # model output (interpolated)
    path_out='/work/bm0982/b380388/icon_postproc/icon_interpolated/'
    pmodel_out='icon_156m'

    if [[ $l_grid == 1 ]]; then
      fname='../../GRIDS/GRID_default_3d_fine_DOM03_ML.nc'
      fname_out=$pmodel_out'_merged_'$domain_name'_grid.nc'
      else
      fname_restart='hdcp2_cosmodom_nest_R0156m_restart_atm_'$date'T'$hr'0000Z.nc'
      fname_2dsurf='2d_surface_day_DOM03_ML_'$date'T'$hr'0000Z.nc'
      fname_2dcloud='2d_cloud_day_DOM03_ML_'$date'T'$hr'0000Z.nc'
      fname_2drad='2d_rad_day_DOM03_ML_'$date'T'$hr'0000Z.nc'
      fname_out=$pmodel_out'_merged_'$date$hr'00_'$domain_name'.nc'
    fi

    
    var_rest2d='sob_s,thb_s,tot_prec,qhfl_s,shfl_s,lhfl_s'
    var_rest3d='vn.TL1,w.TL1,rho.TL1,theta_v.TL1,exner.TL1,qv.TL1'
    var_surf2d='lhfl_s,shfl_s,umfl_s,vmfl_s,ps,tcm,tch'
    var_cloud2d='clt,clch,clcm,clcl,z_pbl,rain_gsp_rate'
    var_rad2d='asob_s,athb_s,rsdscs,rsdsdiff'
    
    lay_rest3d='80/151' #notation beginlayer/endlayer
    
    
    # mesh size
    xinc=0.0015 #156m
    yinc=0.0009 #156m
 

fi


if [[ $l_les312 == 1 ]]; then
    path_restart='/work/bm0982/b380388/extract_les/RESTART/DATA_RESTART'
    path_defout='/work/bm0982/b380388/extract_les/DATA'
    fname_grid=$path_restart'/../../extract_grids/hdcp2_cosmodom_nest_R0312m_'$domain_name'.nc'

 # model output (interpolated)
    path_out='/work/bm0982/b380388/icon_postproc/icon_interpolated'
    pmodel_out='icon_312m'

    if [[ $l_grid == 1 ]]; then
      fname='../../GRIDS/GRID_3d_fine_DOM02_ML_'$domain_name'.nc'
      fname_out=$pmodel_out'_merged_'$domain_name'_grid.nc'
      else
      fname_restart='hdcp2_cosmodom_nest_R0312m_restart_atm_'$date'T'$hr'0000Z_'$domain_name'.nc'
      fname_2dsurf='2d_surface_day_DOM02_ML_'$date'T'$hr'0000Z_'$domain_name'.nc'
      fname_2dcloud='2d_cloud_day_DOM02_ML_'$date'T'$hr'0000Z_'$domain_name'.nc'
      fname_2drad='2d_rad_day_DOM02_ML_'$date'T'$hr'0000Z_'$domain_name'.nc'
      fname_out=$pmodel_out'_merged_'$date$hr'00_'$domain_name'.nc'
    fi

    # mesh size
    xinc=0.003 #312m
    yinc=0.0019 #312m

fi


if [[ $l_les624 == 1 ]]; then
    path_restart='/work/bm0982/b380388/extract_les/RESTART/DATA_RESTART'
    path_defout='/work/bm0982/b380388/extract_les/DATA'
    fname_grid=$path_restart'/../../extract_grids/hdcp2_cosmodom_R0625m_'$domain_name'.nc'
    
 # model output (interpolated)
    path_out='/work/bm0982/b380388/icon_postproc/icon_interpolated'
    pmodel_out='icon_624m'   

    if [[ $l_grid == 1 ]]; then
      fname='../.././GRIDS/GRID_3d_fine_DOM01_ML_'$date'T000000Z_'$domain_name'.nc'
      fname_out=$pmodel_out'_merged_'$domain_name'_grid.nc'
      else 
      fname_restart='hdcp2_cosmodom_R0625m_restart_atm_'$date'T'$hr'0000Z_'$domain_name'.nc'
      fname_2dsurf='2d_surface_day_DOM01_ML_'$date'T'$hr'0000Z_'$domain_name'.nc'
      fname_2dcloud='2d_cloud_day_DOM01_ML_'$date'T'$hr'0000Z_'$domain_name'.nc'
      fname_2drad='2d_rad_day_DOM01_ML_'$date'T'$hr'0000Z_'$domain_name'.nc'
      fname_out=$pmodel_out'_merged_'$date$hr'00_'$domain_name'.nc'
    fi
    
    # mesh size
    xinc=0.0059 #624m
    yinc=0.0038 #624m
    
fi  


###
# COSMO DE/EU 
### 

if [[ $l_cde == 1 ]]; then
    # variables
    mvar="T_GDS10_HYBY_13,U_GDS10_HYBY_13,V_GDS10_HYBY_13,VERT_VEL_GDS10_HYBL_13,QV_GDS10_HYBY_13,PS_GDS10_GPML_13,LAI_GDS10_SFC_13,GEOMET_H_GDS10_HYBL_13,T_GDS10_HYBY_13,PS_GDS10_HYBY_13,ASHFL_S_GDS10_SFC_13,ALHFL_S_GDS10_SFC_13,GEOMET_H_GDS10_SFC_13,CLCT_GDS10_SFC_13,CLCL_GDS10_SFC_13,ASOB_S_GDS10_SFC_13,ATHB_S_GDS10_SFC_13,ALB_RAD_GDS10_SFC_13"
    
    # model input
    pmodel='cde'
    fname='laf'$date$hr

    echo "Processing : " $pmodel " "  $fname 
    
    # model output (interpolated)
    pmodel_out='cde_2800m'
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_'$ext_name'.nc'
    
    # mesh size (native resolution)
    xinc=0.025 #2800m
    yinc=0.025 #2800m    
fi  

if [[ $l_ceu == 1 ]]; then
    # variables
    mvar="T_GDS10_HYBY_13,U_GDS10_HYBY_13,V_GDS10_HYBY_13,VERT_VEL_GDS10_HYBL_13,QV_GDS10_HYBY_13,PS_GDS10_GPML_13,LAI_GDS10_SFC_13,GEOMET_H_GDS10_HYBL_13,T_GDS10_HYBY_13,PS_GDS10_HYBY_13,ASHFL_S_GDS10_SFC_13,ALHFL_S_GDS10_SFC_13,GEOMET_H_GDS10_SFC_13,CLCT_GDS10_SFC_13,CLCL_GDS10_SFC_13,ASOB_S_GDS10_SFC_13,ATHB_S_GDS10_SFC_13,ALB_RAD_GDS10_SFC_13"
    
    # model input
    pmodel='ceu'
    fname='laf'$date$hr
   
    echo "Processing : " $pmodel " "  $fname  
    # model output (interpolated)
    pmodel_out='ceu_7000m'
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_'$ext_name'.nc'

    # mesh size (native resolution)
    xinc=0.0625 #7000m
    yinc=0.0625 #7000m
fi  
 
 
###
# GME
### 


if [[ $l_gme == 1 ]]; then
    # model input
    pmodel='gme'
#    fname='gaf'$date$hr # depend on which data were downloading
    fname='giff'$date$hr
#    fname='invar.i384a.2012022900' # to extract external files

    echo "Processing : " $pmodel " "  $fname     
    # model output (interpolated)
    pmodel_out='gme_20000m'
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_'$ext_name''

    # mesh size (native resolution)
    xinc=0.2838 #20000m 
    yinc=0.1797 #20000m 
    
fi
 

##############
# Section 3: 
# Preparation of namelist for cdo-interpolation
##############

   if [[ $l_mistral == 1 ]]; then      
      module load ncl/6.3.0-gccsys 
      module load nco/4.5.0-gcc48
   #   module load python/2.7-ve0
   fi 

# ******* DO NOT CHANGE ANYTHING BEHIND THIS LINE ********   
   
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

if [ $l_les156 == 1 ] || [ $l_les312 == 1 ] || [ $l_les624 == 1 ]; then


 echo "interpoalte 2D restart"
 cdo -O remapnn,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rest2d -selltype,1 $path_restart"/"$fname_restart $path_out'/restart_2d_reglonlat.nc'
 echo "interpolate 3D restart"
 cdo -O remapnn,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rest3d -sellevidx,$lay_rest3d $path_restart"/"$fname_restart $path_out'/restart_3d_reglonlat.nc'
 echo "interpolate 2D surface"
 cdo -O remapnn,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_surf2d $path_defout"/"$fname_2dsurf $path_out'/2dsurf_reglonlat.nc'
 echo "interpolate 2d Cloud"
 cdo -O remapnn,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_cloud2d $path_defout"/"$fname_2dcloud $path_out'/2dcloud_reglonlat.nc'
 echo "interpolate 2D Radiation"
 cdo -O remapnn,$grid_file -sellonlatbox,$lonsta,$lonend,$latsta,$latend -setgrid,$fname_grid -selvar,$var_rad2d $path_defout"/"$fname_2drad $path_out'/2drad_reglonlat.nc'
 echo "merge data"
 cdo merge $path_out"/restart_2d_reglonlat.nc" $path_out"/restart_3d_reglonlat.nc" $path_out"/2dsurf_reglonlat.nc" $path_out'/2dcloud_reglonlat.nc' $path_out'/2drad_reglonlat.nc'  $path_out'/'$fname_out
 
  # delete unessesary file
  rm $path_out'/restart_2d_reglonlat.nc'
  rm $path_out'/restart_3d_reglonlat.nc'
  rm $path_out'/2dsurf_reglonlat.nc'
  rm $path_out'/2drad_reglonlat.nc'
  
 
fi


if [ $l_cde == 1 ] || [ $l_ceu == 1 ]; then
    
    ncl_convert2nc $path"/"$pmodel"/"${fname}".grb" -B
    mv ${fname}".nc" ${path_out}

    # select variables because some variables causes error in the transformation    
    echo "cdo select"
    cdo select,name=$mvar $path_out"/"$fname".nc" $path_out"/temporary_int2reg_file.nc"
    ncatted -a coordinates,VERT_VEL_GDS10_HYBL_13,c,c,"g10_lon_1 g10_lat_0"  $path_out"/temporary_int2reg_file.nc"

    # interpolation
    echo "cdo remapdis,$grid_file $path_out"/temporary_int2reg_file.nc" $path_out"/"$fname_out"
    cdo remapdis,$grid_file $path_out"/temporary_int2reg_file.nc" $path_out"/"$fname_out
    
    # delete unessesary file
    rm $path_out"/temporary_int2reg_file.nc"
    rm $path_out"/"$fname".nc"
fi

if [[ $l_gme == 1 ]]; then
    
    # interpolation
    echo "cdo remapdis,$grid_file $path"/"$pmodel"/"$fname $path_out"/"$fname_out"
    cdo remapdis,$grid_file $path"/"$pmodel"/"$fname $path_out"/"$fname_out".grb"
    
    # convert to netcdf
    ncl_convert2nc ${path_out}"/"${fname_out}".grb" -B
    mv ${fname_out}".nc" ${path_out}
    rm ${path_out}"/"${fname_out}".grb"
fi

##########
###
##########

 done # for ihr loop

