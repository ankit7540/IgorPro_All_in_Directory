
// Replace region of wave with zeroes except 7 points on both sides of the band (or signal)
// Runs over firstNum to lastNum for all waves with matching prefixString
// Output is saved in a new folder called `processed`

 
Function Replace_noise_with_zero(prefixString, firstNum, lastNum)
	String prefixString		// The part of the name that is common to all waves.
	Variable firstNum		// Number of the first wave in the series.
	Variable lastNum		// Number of the last wave in the series.
 
 
	Variable n
	String currentWaveName
	
	DFREF cdf1=getdatafolderDFR()
	newdatafolder /O /S processed
	DFREF cdf2=getdatafolderDFR()
	
	setdatafolder cdf1
	//-----------------------------------------------------
	// To be used in the assignment of zero 
	 	variable a1,a2,b1,b2,c1,c2,d1,d2,e1,e2,f1,f2,g1,g2,h1,h2,i1,i2

		a1=0  ;  a2=208
		b1=225 ; b2=302
		c1=319 ; c2=401 // to 415
		d1=415  ; d2=715  
		e1=730    ; e2=823
		f1=840  ;f2 =932
		g1=947 ; g2=1041
		h1=1056 ; h2=1149
		i1=1163  ; i2=1339
	
	
	//------------------------------------------------------
	
	
	
	For (n=firstNum; n<=lastNum; n+=1)
		sprintf currentWaveName, "%s%d", prefixString, n
 
		WAVE currentWave = $(currentWaveName) 
		//print nameofwave(currentWave), dimsize(currentWave,0)   
		
		wave inpw=currentWave
		wave xwave=root:high_pressure:evac_removed:xpnt
		
		variable x1,x2
		x1=dimsize(inpw,0)
		//print x1
 		//-----------------------------------------------------------
 		setdatafolder cdf2
 		
 		string new_name
 		sprintf new_name,"%s_%g", removeending(prefixString,"_blr_"),n
		make /o /d /n=(x1) $new_name=inpw
		wave nwave=$new_name
 		
 		// replacing with zeroes here using loop--
 		
 		wave nsw= nwave	
 		variable j=0
		for (j=a1; j< (a2+1); j=j+1)
		nsw[j]=0
		endfor 
	
		for (j=b1; j< (b2+1); j=j+1)
		nsw[j]=0
		endfor 
		
		for (j=c1; j< (c2+1); j=j+1)
		nsw[j]=0
		endfor 
		
		for (j=d1; j< (d2+1); j=j+1)
		nsw[j]=0
		endfor 
	
		for (j=e1; j< (e2+1); j=j+1)
		nsw[j]=0
		endfor 
	
		for (j=f1; j< (f2+1); j=j+1)
		nsw[j]=0
		endfor 
	
		for (j=g1; j< (g2+1); j=j+1)
		nsw[j]=0
		endfor 
	
		for (j=h1; j< (h2+1); j=j+1)
		nsw[j]=0
		endfor 
		
		for (j=i1; j< (i2+1); j=j+1)
		nsw[j]=0
		endfor 
 		
 		
 		//--------------------------------------------------
 		
 		
 		setdatafolder cdf1
 		//-----------------------------------------------------------
	EndFor
	print "processed"
End

//--------------------------------------------------------------------------------------------------------------------------------
