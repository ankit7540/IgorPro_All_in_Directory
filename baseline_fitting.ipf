#pragma rtGlobals=3		// Use modern global access method and strict wave access.
//---------------------------------------------------------------------------------------------------------
// Author : Ankit Raj
// Fit baseline for a wave with a polynomial. Processes all waves in a folder which have matching prefixString 
// and firstNum to lastNum. 
// Generates the fitted baseline and baseline removed (processed wave with "blr_index appended to the prefix string") 
// polynomial baseline is not saved.
//---------------------------------------------------------------------------------------------------------
 
Function Baseline_fitting_batch(prefixString, firstNum, lastNum)
	String prefixString		// The part of the name that is common to all waves.
	Variable firstNum		// Number of the first wave in the series.
	Variable lastNum		// Number of the last wave in the series.
 
 	make /o /d /n=(lastNum,4) fit_param	; make /o /d /n=(4) W_coef=0
 	wave dataset_wave=fit_param
 	wave W_coef=W_coef
 	
 	// Change the path of the following waves.
 	wave xwave= root:low_pressure:evac_removed:xpnt
	wave mask_wave=root:low_pressure:evac_removed:Mask_baseline_inp00
	 if(!WaveExists(xwave) & !WaveExists(mask_wave) )
		Abort "Missing wave : 'xwave' describing the point is missing or the 'mask wave' is missing. Check."
	endif
	//------------------------------------------------------------------------
	Variable n
	String currentWaveName
	For (n=firstNum; n<=lastNum; n+=1)
		sprintf currentWaveName, "%s%d", prefixString, n
 
		WAVE currentWave = $(currentWaveName) 
		printf "%s " nameofwave(currentWave), dimsize(currentWave,0)   
		
		wave inpw=currentWave
		make /FREE /D /N=1340 spectra=inpw
		wave free_spectra=spectra
		
		portion_to_nan(free_spectra, 463  ,  657 )
		 
 		//-----------------------------------------------------------
 		CurveFit /Q poly 5, free_spectra /X=xwave /M=mask_wave  
 		dataset_wave[n-1][0]=K0
		dataset_wave[n-1][1]=K1
		dataset_wave[n-1][2]=K2
		dataset_wave[n-1][3]=K3
 		
 		string blname, baseline_rem
		sprintf blname,"poly3_bl_%g",n
		sprintf baseline_rem,"%sblr_%g",prefixString,n
		//print sname, blname
		make /FREE /o /d /n=1340 polynomial_baseline=poly(W_coef,xwave)
 		make /o /d /n=1340 $baseline_rem=inpw   - polynomial_baseline
 		wave bl_rem=$baseline_rem
 		
 		//-----------------------------------------------------------
	EndFor
	print ""; print "processed"
End
//---------------------------------------------------------------------------------------------------------
