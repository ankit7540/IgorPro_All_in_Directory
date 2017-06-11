#pragma rtGlobals=3		// Use modern global access method and strict wave access.
//---------------------------------------------------------------------------------------------------------
// Author : Ankit Raj
// Fit baseline for a wave with cubic polynomial. Processes all waves in a folder which have matching prefixString 
// and firstNum to lastNum.
// Generates the fitted baseline and baseline removed (processed wave with "blr_index appended to the prefix string") 

// Required waves :
// xpnt : xpoint wave for marking the x-point of the wave
// mask : mask wave for marking the region to be excluded from the fit. 
// Enter the path to these waves in the program below.
 
Function Baseline_fitting_batch(prefixString, firstNum, lastNum)
	String prefixString		// The part of the name that is common to all waves.
	Variable firstNum		// Number of the first wave in the series.
	Variable lastNum		// Number of the last wave in the series.
 
 	make /o /d /n=(lastNum,4) fit_param	
	make /o /d /n=(4) W_coef=0
 	wave dataset_wave=fit_param
 	wave W_coef=W_coef
 
	Variable n
	String currentWaveName
	For (n=firstNum; n<=lastNum; n+=1)
		sprintf currentWaveName, "%s%d", prefixString, n
 
		WAVE currentWave = $(currentWaveName) 
		printf "%s " nameofwave(currentWave), dimsize(currentWave,0)   
		
		wave inpw=currentWave
		wave xwave=root:high_pressure:evac_removed:xpnt
		wave mask_wave=root:high_pressure:evac_removed:Mask_baseline_inp00
 		//-----------------------------------------------------------
 		CurveFit /Q poly 4, inpw /X=xwave /M=mask_wave  
 		dataset_wave[n-1][0]=K0
		dataset_wave[n-1][1]=K1
		dataset_wave[n-1][2]=K2
		dataset_wave[n-1][3]=K3
 		
 		string blname, baseline_rem
		sprintf blname,"poly3_bl_%g",n
		sprintf baseline_rem,"%sblr_%g",prefixString,n
		//print sname, blname
		make /o /d /n=1340 $blname=poly(W_coef,xwave)
 		wave baseline=$blname
 		make /o /d /n=1340 $baseline_rem=inpw  - baseline
 		//-----------------------------------------------------------
	EndFor
	print ""
	print "processed"
End
//---------------------------------------------------------------------------------------------------------
