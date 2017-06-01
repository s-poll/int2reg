#!/bin/bash

#############################
###  This porgram is for interpolate GME/COSMO data 2 regular lon lat 
###
###  
###
###
###
#############################

#source ~/.cshrc
#source ~/.bashrc
#echo $PATH

# # DOM3 0.156, DOM2 0.312, DOM1 0.625 
# # 
# resolution = 0.156
# resolution_factor = 1 # for every else grid 0.67 # for icon

# ; juelich
#     lons = 6.414
#     lats = 50.909
# ;; 
# ;; cabauw  
# ;;    lons     = 4.927
# ;;    lats     = 51.971
# 
# ;; lindenberg    
#     ;lons = 14.122
#     ;lats = 52.209
# 
# ;; melpitz
#     ;lons = 12.930
#     ;lats = 51.525


# # use pyhton on mistral /work/bm0982/b380388/icon_postproc/utils
# python gridspec.py --resolution=0.10452 --bounds 5.914,6.914,50.404,51.0409


# # initilization of variables as interge r
#typeset -i  lons lats ext_deg xinc yinc 


##############
#  Setting
##############
    
# location
 lons=6.414 # lon
 lats=50.909 # lat

# extinction
#   ext_deg_x=0.6 #lon
#   ext_deg_y=0.4 #lat
#   ext_deg_x=0.75 #lon
#   ext_deg_y=0.5 #lat
  ext_deg_x=1.25 #lon
  ext_deg_y=0.85 #lat
#  ext_deg_x=4.0 #lon
#  ext_deg_y=2.0 #lat
 
 
# model choice
# only one model per execution
l_les156_msim=0
l_les312_msim=0
l_les624_msim=0
l_les156=0
l_les312=0
l_les624=0
l_cde=0
l_ceu=1
l_gme=0

# for icon LAI_GDS10_SFC_13 (special lai for gme)
l_les_lai=0
 
# 
domain_name='juelich'
date='20130424'
hr='11'
 
##############
#  Model choice
##############

ext_name=$(echo "scale=0;($ext_deg_x*100)" | bc)
ext_name=${ext_name%.*} # float to int


###
# ICON LES from M-project
###

if [[ $l_les624_msim == 1 ]]; then
#    path='/automount/ags/s6stpoll/PHD_data/ICON_NWP/ICON_GRIDS/'
    path='/automount/buffer180d-2/les/extract_les/juelich_restart/DATA2'
    fname_grid=$path'/GRID_3d_fine_DOM01_ML_20130424T000000Z_juelich_rec.nc'
    
 # model output (interpolated)
    path_out='/automount/ags/s6stpoll/PHD_data/model_interpolated'
    pmodel_out='les_mproject_624m'    
     
    if [[ $l_les_lai == 1 ]]; then
      fname='extpar_hdcp2_cosmodom_R0625m.nc'
      fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext'$ext_name'_laig.nc'
      else 
      fname='theta_test.nc'
      #fname='hdcp2_cosmodom_R0625m_restart_atm_'$date'T'$hr'0000Z_juelich_rec.nc'
      fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext0'$ext_name'.nc'
    fi
    
    # mesh size
    xinc=0.0059 #624m
    yinc=0.0038 #624m
    
fi  
 

###
# ICON LES 
###

# model input
if [[ $l_les156 == 1 ]]; then
    path='/automount/ags/s6stpoll/PHD_data/LES-simulation/own_simulation/'$date
    pmodel='out_les'
    
    # model output (interpolated)
    path_out='/automount/ags/s6stpoll/PHD_data/model_interpolated'
    pmodel_out='les_156m'    
    
    if [[ $l_les_lai == 1 ]]; then
      fname='GRID_DOM03_ML_20130420T000000Z.nc'
      fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext'$ext_name'_laig.nc'
      else
      fname='out_156m_DOM03_ML_'$date'T'$hr'0000Z.nc'
      fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext0'$ext_name'.nc'
    fi
    
    # mesh size
    xinc=0.0015 #156m
    yinc=0.0009 #156m
fi  

if [[ $l_les312 == 1 ]]; then
    path='/automount/ags/s6stpoll/PHD_data/LES-simulation/own_simulation/'$date
    pmodel='out_les'

    
    # model output (interpolated)
    path_out='/automount/ags/s6stpoll/PHD_data/model_interpolated'
    pmodel_out='les_312m'    
    
    if [[ $l_les_lai == 1 ]]; then
      fname='GRID_DOM02_ML_20130420T000000Z.nc'
      fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext'$ext_name'_laig.nc'
      else
      fname='out_312_DOM02_ML_'$date'T'$hr'0000Z.nc'
      fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext0'$ext_name'.nc'
    fi

    
    #mesh size
    xinc=0.003 #312m
    yinc=0.0019 #312m
fi  


if [[ $l_les624 == 1 ]]; then
    path='/automount/ags/s6stpoll/PHD_data/LES-simulation/own_simulation/'$date
    pmodel='out_les'

    # model output (interpolated)
    path_out='/automount/ags/s6stpoll/PHD_data/model_interpolated'
    pmodel_out='les_624m'    
     
    if [[ $l_les_lai == 1 ]]; then
      fname='GRID_DOM01_ML_20130420T000000Z.nc'
      fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext'$ext_name'_laig.nc'
      else 
      fname='out_624m_DOM01_ML_'$date'T'$hr'0000Z.nc'
      fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext0'$ext_name'.nc'
    fi
    
    # mesh size
    xinc=0.0059 #624m
    yinc=0.0038 #624m
    
fi 

 
###
# COSMO DE/EU 
### 

if [[ $l_cde == 1 ]]; then
    # model input
    path='/automount/ags/s6stpoll/analysen'
    path='/automount/cluma06/agb/s6stpoll/analysen'
    path='/automount/cluma05/s6stpoll/analysen'
    pmodel='cde'
    fname='laf'$date$hr
    

    # model output (interpolated)
    path_out='/automount/ags/s6stpoll/PHD_data/model_interpolated'
    pmodel_out='cde_2800m'
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext'$ext_name'.nc'

    # mesh size
    xinc=0.025 #2800m
    yinc=0.025 #2800m    
fi  

if [[ $l_ceu == 1 ]]; then
    # model input
    path='/automount/ags/s6stpoll/analysen'
    path='/automount/cluma06/agb/s6stpoll/analysen' 
    path='/automount/cluma05/s6stpoll/analysen'
    pmodel='ceu'
    fname='laf'$date$hr
    

    # model output (interpolated)
    path_out='/automount/ags/s6stpoll/PHD_data/model_interpolated'
    pmodel_out='ceu_7000m'
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext'$ext_name'.nc'

    # mesh size
    xinc=0.0625 #7000m
    yinc=0.0625 #7000m

fi  
 

 
###
# GME
### 


if [[ $l_gme == 1 ]]; then
    # model input
#    path='/automount/ags/s6stpoll/analysen'
    path='/automount/agb/s6mahack/data'
    pmodel='gme'
#    fname='gaf'$date$hr
    fname='giff'$date$hr

    # model output (interpolated)
    path_out='/automount/ags/s6stpoll/PHD_data/model_interpolated'
    pmodel_out='gme_20000m'
#    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext0'$ext_name''
    fname_out=$pmodel_out'_'$date$hr'00_'$domain_name'_ext0'$ext_name'_f'

    if [[ $l_les_lai == 1 ]]; then
      # to extract lai_mx
      fname='invar.i384a.2012022900'
      fname_out=$pmodel_out'_'$domain_name'_ext'$ext_name''
    fi 
    
    # mesh size
    xinc=0.2838 #20000m 
    yinc=0.1797 #20000m 
    
fi
 

##############
# calculation
##############

 xfirst=$(echo "$lons - $ext_deg_x"|bc)
 yfirst=$(echo "$lats - $ext_deg_y"|bc)

 xsize=$(echo "scale=0;($ext_deg_x*2)/$xinc" | bc)
 ysize=$(echo "scale=0;($ext_deg_y*2)/$yinc" | bc)
 
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




if [[ $l_les624_msim == 1 ]]; then
    # interpolation
    echo "cdo setgrid,$fname_grid $path"/"$fname $path_out"/test.nc""
    cdo setgrid,$fname_grid $path"/"$fname $path_out"/test.nc"
#     echo "cdo remapdis,$grid_file $path"/"$fname $path_out"/"$fname_out"
#     cdo remapdis,$grid_file $path"/"$fname $path_out"/"$fname_out
    
fi



if [ $l_les156_msim == 1 ] || [ $l_les312_msim == 1 ]; then
    # interpolation
    echo "cdo remapdis,$grid_file $path"/"$fname $path_out"/"$fname_out"
    cdo remapdis,$grid_file $path"/"$fname $path_out"/"$fname_out
    
fi




if [ $l_les156 == 1 ] || [ $l_les312 == 1 ]||[ $l_les624 == 1 ]; then
    # interpolation
    echo "cdo remapdis,$grid_file $path"/"$pmodel"/"$fname $path_out"/"$fname_out"
    cdo remapdis,$grid_file $path"/"$pmodel"/"$fname $path_out"/"$fname_out
    
fi



if [ $l_cde == 1 ] || [ $l_ceu == 1 ]; then
    # um die probleme mit grib zu lösen
    

    # export GRIB_INVENTORY_MODE=time
    # echo "$path"/"$pmodel"/"$fname $path_out"/test.nc""
    # cdo -f nc copy $path"/"$pmodel"/"$fname $path_out"/test.nc"  # does not work
    #echo "ncl_convert2nc "$fname".grb" -i $path"/"$pmodel"/ -o $path_out"/""

#    /bin/csh -c "ncl_convert2nc "$fname".grb" -i $path"/"$pmodel"/ -o $path_out"/""
    ncl_convert2nc "$fname".grb" -i $path"/"$pmodel"/ -o $path_out"/"
    echo "if error occure, do the following command manuelly in the task"
    echo "ncl_convert2nc "$fname".grb" -i $path"/"$pmodel"/ -o $path_out"/""
    
    # select variables because some variables causes error in the transformation    
    echo "cdo select"
    cdo select,name=T_GDS10_HYBY_13,U_GDS10_HYBY_13,V_GDS10_HYBY_13,VERT_VEL_GDS10_HYBL_13,QV_GDS10_HYBY_13,PS_GDS10_GPML_13,LAI_GDS10_SFC_13,GEOMET_H_GDS10_HYBL_13,T_GDS10_HYBY_13,PS_GDS10_HYBY_13,ASHFL_S_GDS10_SFC_13,ALHFL_S_GDS10_SFC_13,GEOMET_H_GDS10_SFC_13,CLCT_GDS10_SFC_13,CLCL_GDS10_SFC_13,ASOB_S_GDS10_SFC_13,ATHB_S_GDS10_SFC_13,ALB_RAD_GDS10_SFC_13 $path_out"/"$fname".nc" $path_out"/test_2.nc"
    ncatted -a coordinates,VERT_VEL_GDS10_HYBL_13,c,c,"g10_lon_1 g10_lat_0"  $path_out"/test_2.nc"

    # interpolation
    echo "cdo remapdis,$grid_file $path_out"/test_2.nc" $path_out"/"$fname_out"
    cdo remapdis,$grid_file $path_out"/test_2.nc" $path_out"/"$fname_out
    
    # delete unessesary file
    rm $path_out"/test_2.nc"
    rm $path_out"/"$fname".nc"
fi




if [[ $l_gme == 1 ]]; then
    
    # interpolation
    echo "cdo remapdis,$grid_file $path"/"$pmodel"/"$fname $path_out"/"$fname_out"
    cdo remapdis,$grid_file $path"/"$pmodel"/"$fname $path_out"/"$fname_out".grb"
    
    /bin/csh -c "ncl_convert2nc "$fname_out".grb" -i $path_out"/"$pmodel"/ -o $path_out"/""
    echo "if error occure, do the following command manuelly in the task"
    echo "ncl_convert2nc "$fname_out".grb" -i $path_out"/"$pmodel"/ -o $path_out"/""
    echo "delete if poosible the "$fname_out".grb file in "$path_out"/"$pmodel
    
    
fi








# friedhof code:
# 
#     fname='extpar_hdcp2_cologne_nest_260km_0624m.nc' # do not work because no grid find
## cdo remapdis,$grid_file -setgrid,$path"/"$pmodel"/out_624m_DOM01_ML_20130424T120000Z.nc" $path"/"$pmodel"/"$fname $path_out"/"$fname_out
# 
#
# cat > targetgrid.txt << EOF
# gridtype   = lonlat
# gridsize   = 413136
# xname      = lon
# xlongname  = longitude
# xunits     = degrees_east
# yname      = lat
# ylongname  = latitude
# yunits     = degrees_north
# xsize      = 604
# ysize      = 684
# xfirst     = 5.9633
# xinc       = 0.0015
# yfirst     = 50.5992
# yinc       = 0.0009
# EOF


# cdo remapdis,targetgrid.txt /work/bm0982/b380388/icon_output/juelich_70km_130420_3nest/out_156m_DOM03_ML_20130420T120000Z.nc ./var_int_0156.nc


# cdo remapdis,targetgrid.txt /work/bm0834/k203095/OUTPUT/20130424/DATA/2d_surface_day_DOM03_ML_20130424T120000Z.nc /automount/cluma05/s6stpoll/ncl/interpolation/extpar_int_625m.nc

# cdo remapdis,targetgrid.txt /automount/ags/s6stpoll/PHD_data/ICON_NWP/ICON_GRIDS/extpar_hdcp2_cosmodom_R0625m.nc /automount/cluma05/s6stpoll/ncl/interpolation/extpar_int_625m.nc
