Overview available Variables HDCP2 S4 project	LEGEND			
						x		available	
						-		not available	
									
2D Variables ICON-LEM, COSMO, GME
		ICON-156		ICON-312		ICON-624		Name in ICON 		CDE	CEU	Name in COSMO		GME	Name in GME
Tot Precip	x (2d_cloud,restart)	x (2d_cloud,restart)	x (2d_cloud,restart)	rain_gsp_rate, tot_prec	x	x	TOT_PREC, RAIN_GSP	x	TOT_PREC, RAIN_GSP
CLCT		x (2d_cloud)		x (2d_cloud)		x (2d_cloud)		clct			x	x	CLCT			x	CLCT
CLCL		x (2d_cloud)		x (2d_cloud)		x (2d_cloud)		clcl			x	x	CLCL			x	CLCL
CLCM		x (2d_cloud)		x (2d_cloud)		x (2d_cloud)		clcm			x	x	CLCM			x	CLCM
CLCH		x (2d_cloud)		x (2d_cloud)		x (2d_cloud)		clch			x	x	CLCH			x	CLCH
Z PBL		x (2d_cloud)		x (2d_cloud)		x (2d_cloud)		z_pbl			-	-				-	
SHF		x (2d_surface, restart)	x (2d_surface, restart)	x (2d_surface, restart)	shfl_s			x	x	ASHFL_S			x	ASHFL_S
LH		x (2d_surface, restart)	x (2d_surface, restart)	x (2d_surface, restart)	lhfl_s			x	x	ALHFL_S			x	ALHFL_S
U-mom.		x (2d_surface, restart)	x (2d_surface, restart)	x (2d_surface, restart)	umfl_s			x	x	AUMFL_S			x	AUMFL_S
V-mom		x (2d_surface, restart)	x (2d_surface, restart)	x (2d_surface, restart)	vmfl_s			x	x	AVMFL_S			x	AVMFL_S
Net SW RAD	x (2d_rad, restart)	x (2d_rad, restart)	x (2d_rad, restart)	asob_s			x	x	ASOB_S			x	ASOB_S
Net LW RAD	x (2d_rad, restart)	x (2d_rad, restart)	x (2d_rad, restart)	athb_s			x	x	ATHB_S			x	ATHB_S
W so		x (2d_surface, restart)	x (2d_surface, restart)	x (2d_surface, restart)	mrlsl			x	x	W_SO			x	W_SO
T so		x (2d_surface, restart)	x (2d_surface, restart)	x (2d_surface, restart)	tsl			x	x	T_SO			x	T_SO
LAI		x (extpar)		x (extpar)		x (extpar)		LAI_MX (max)		x	x	LAI			x	LAI_MX (max)
ALBEDO		x (extpar)		x (extpar)		x (extpar)					x	x	ALB_RAD			x	ALB_RAD
CAPE		-	-		-									x	x	CAPE_ML			-	
CIN		-	-		-									x	x	CIN_ML			-	
IWV		x (2d_cloud)		x (2d_cloud)		x (2d_cloud)		prw			x	x	TQV			x	TQV
LWP		QC?			x			x			TWATER? QC?							-	
2m temp		x (2d_surface)		x (2d_surface)		x (2d_surface)					x	x	T_2m			???	
2m qv		x (2d_surface)		x (2d_surface)		x (2d_surface)		huss			x	x	QV_2m			-	
p srf		x (2d_surface)		x (2d_surface)		x (2d_surface)		ps			x	x	PS			x	PS
tcm		x (2d_surface, restart)	x (2d_surface, restart)	x (2d_surface, restart)	tcm			x	x	TCM			x	TCM
tch		x (2d_surface, restart)	x (2d_surface, restart)	x (2d_surface, restart)	tch			x	x	TCH			x	TCH
									
									
									
									
									
									
3D Variables	ICON-LEM, COSMO, GME	
	ICON-156	ICON-312	ICON-624	Name in ICON			CDE	CEU	Name in COSMO	GME	Name in GME
U	x (restart) 	x (restart) 	x (restart) 	VN.TL1,VT.TL1, need int.	x	x	U	x	U
V	x (restart)	x (restart)	x (restart)	VN.TL1,VT.TL1, need int.	x	x	V	x	V
W	x (restart)	x (restart)	x (restart)	W.TL1				x	x	W	x	OMEGA (pa)
T	x (restart)	x (restart)	x (restart)	thetae.TL1, need Pres (Exner)	x	x	T	x	T
Pres	x (restart)	x (restart)	x (restart)	EXNER.TL1			x	x	P (PP)	x	FI (geopot)
QV	x (restart)	x (restart)	x (restart)	QV.TL1				x	x	QV	x	QV
QC	x (restart)	x (restart)	x (restart)	QC.TL1				x	x	QC	x	QC
TKE	x but buggy! 	x but buggy! 	x but buggy! 	TKE.TL1				x	x	TKE	-	
TKVH	-	-	-								x	x	TKVH	-	
TKVM	-	-	-								x	x	TKVM	-	

