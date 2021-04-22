/***********************************************************************************
** DISCLAIMER                                                                     **
**                                                                                **
**   SMIC hereby provides the quality information to you but makes no claims,     **
** promises or guarantees about the accuracy, completeness, or adequacy of the    **
** information herein. The information contained herein is provided on an "AS IS" **
** basis without any warranty, and SMIC assumes no obligation to provide support  **
** of any kind or otherwise maintain the information.                             **
**   SMIC disclaims any representation that the information does not infringe any **
** intellectual property rights or proprietary rights of any third parties.SMIC   **
** makes no other warranty, whether express, implied or statutory as to any       **
** matter whatsoever,including but not limited to the accuracy or sufficiency of  **
** any information or the merchantability and fitness for a particular purpose.   **
** Neither SMIC nor any of its representatives shall be liable for any cause of   **
** action incurred to connect to this service.                                    **
**                                                                                **
** STATEMENT OF USE AND CONFIDENTIALITY                                           **
**                                                                                **
**   The following/attached material contains confidential and proprietary        **
** information of SMIC. This material is based upon information which SMIC        **
** considers reliable, but SMIC neither represents nor warrants that such         **
** information is accurate or complete, and it must not be relied upon as such.   **
** This information was prepared for informational purposes and is for the use    **
** by SMIC's customer only. SMIC reserves the right to make changes in the        **
** information at any time without notice.                                        **
**   No part of this information may be reproduced, transmitted, transcribed,     **
** stored in a retrieval system, or translated into any human or computer         **
** language, in any form or by any means, electronic, mechanical, magnetic,       **
** optical, chemical, manual, or otherwise, without the prior written consent of  **
** SMIC. Any unauthorized use or disclosure of this material is strictly          **
** prohibited and may be unlawful. By accepting this material, the receiving      **
** party shall be deemed to have acknowledged, accepted, and agreed to be bound   **
** by the foregoing limitations and restrictions. Thank you.                      **
************************************************************************************
**  Check tool version:
**  VCS       :  vcs_2011.12-SP1
**  NC-Verilog:  INCISIV10.20.035
**  ModelSim  :  ams_2012.1_1 
** 
************************************************************************************
**  Project : S018PLLGS_LC (IP DesignKit)                                                              
**                                                                                 
************************************************************************************
**  History:                                                                      
**  Version   Date         Author       Description                               
************************************************************************************
** V1.1.1    2007/09/03    Ginger      Initial Version.
** V1.1.2   2013/11/17    Kessy       Improve the verilog behavior for XIN change case and CLK_OUT out of range case 
***********************************************************************************/


`celldefine
`timescale 1ns/1ps
        
  `define LT_in		     500000  
  `define BP_delay	     2  
  `define M_min 	     0  
  `define N_min 	     0 
  `define CLK_OUT_min	     100  
  `define CLK_OUT_max	     250
  `define XIN_N_min	     1 
  `define XIN_N_max	     25
  `define LKDT_in_SLEEP12    1'bx   
  `define CLK_OUT_in_SLEEP12 1'bx 
  `define unknown_value      1'bx
  `define CLK_OUT_in_lock    1'bx
      
module S018PLLGS_LC ( 
   AVDD, 
   AVSS, 
   XIN, 
   CLK_OUT, 
   N, 
   M, 
   TST_OUT,
   PLL_TST,
   RESET, 
   PD, 
   OD, 
   BP,
   OE 
   );
   
   parameter LT=`LT_in;

   inout   AVDD;
   inout   AVSS;
   input   XIN; 		// input	
   output  CLK_OUT;		// PLL, clock out
   output  TST_OUT;		// Test mode output 
   input   [4:0]   N;		// Input 5-bit divider control pins.
   input   [8:0]   M;		// Feed Back 9-bit divider control pins.
   input   RESET;		// Reset =0 should be used in normal PLL operation.
   input   PD;  		// PLL Power down mode, active high
   input   [3:0] OD;		// Output divider control pin
   input   [1:0] PLL_TST;	// M and N divider test mode 
   input   BP;  		// PLL bypass mode selection
   input   OE;  		// CLK_OUT enable pin, active low 

   
   

//////buffer////////
   wire CLK_OUTi, TST_OUTi, XINi, RESETi, PDRSTi, BPi, CLK_OUT, LKDT, LKDTi, OEi, TST_OUT;
   wire [4:0] Ni;
   wire [3:0] ODi;
   wire [1:0] PLL_TSTi;
   wire [8:0] Mi;
   
   buf(OEi,OE);   
   buf(LKDT,LKDTi);   
   buf(XINi,XIN);
   buf(RESETi,RESET);
   buf(PDRSTi,PD);
   buf(BPi,BP);
   buf(TST_OUT,TST_OUTi);
   buf(CLK_OUT,CLK_OUTi);
   buf(Ni[0],N[0]);
   buf(Ni[1],N[1]);
   buf(Ni[2],N[2]);
   buf(Ni[3],N[3]);
   buf(Ni[4],N[4]);
   buf(Mi[0],M[0]);
   buf(Mi[1],M[1]);
   buf(Mi[2],M[2]);
   buf(Mi[3],M[3]);
   buf(Mi[4],M[4]);
   buf(Mi[5],M[5]);
   buf(Mi[6],M[6]);
   buf(Mi[7],M[7]);
   buf(Mi[8],M[8]);
   buf(ODi[0],OD[0]);
   buf(ODi[1],OD[1]);
   buf(ODi[2],OD[2]);
   buf(ODi[3],OD[3]);
   buf(PLL_TSTi[0],PLL_TST[0]);
   buf(PLL_TSTi[1],PLL_TST[1]);

//////internal signal///////
   real XIN_period, XIN_period_p, pre_r_time, XIN_frq_divN, clk_frq_xNO, XIN_period_max; 
   real clk_out_delay, dvd, Mi_real, Ni_real; 
   reg [2:0] cond;
   wire clk_valid, lkdt_en, xin_bypass; 
   reg st_r, clk_out, XIN_change, unknow_XIN, sample_XIN0, sample_XIN1; 
   reg unknow_N, unknow_M, unknow_BP, unknow_OD, unknow_RESET, unknow_PDRST, unknow_OE, unknow_PLL_TST;
   wire unknow;
   reg XIN_change_pre, XIN_change_post;   
   
/////RESET must be low//////
   always @(PLL_TSTi)
   begin
      if(PLL_TSTi!=2'b00)
      begin
	  $display("****************************************************");
	  $display("Warning at %fns : Please fix PLL_TST[1:0]=0 in the normal Mode.",$realtime); 
      end   
   end   
   
   always @(RESETi)
   begin
      if(RESETi!=1'b0)
      begin
	  $display("****************************************************");
	  $display("Error at %fns : Please fix RESET=0 in the normal PLL operation.",$realtime); 
      end   
   end      


/////initial 
   initial 
   begin
     XIN_period_max = 1000/(`XIN_N_min*(`N_min+2));
     pre_r_time = $realtime;
     clk_out = 1'b0;
     clk_out_delay = 5;
     st_r = 1'b0;
     unknow_XIN = 1'b0;
     unknow_PDRST = 1'b0;
     unknow_N = 1'b0;
     unknow_M = 1'b0;
     unknow_PLL_TST = 1'b0;
     unknow_BP = 1'b0; 
     unknow_OD = 1'b0; 
     unknow_RESET = 1'b0; 
     unknow_OE = 1'b0;  
     dvd =1;
     XIN_period = 1; 
     XIN_change = 0;
     cond = 3'b111;
     sample_XIN0 = 0;
     sample_XIN1 = 1;
     XIN_change_pre = 0; 
     XIN_change_post = 0;    
   end  
   
   always @(Mi)
      Mi_real=2+Mi;
      
   always @(Ni)
      Ni_real=2+Ni;
                
///////output divider//////
   always @(ODi)
   begin
      dvd = ODi[3]*8+ODi[2]*4+ODi[1]*2+ODi[0]*1;
   end     
   
//////XINi period///////////
   always @(posedge XINi)
   begin
      XIN_period_p <= XIN_period;
      XIN_period <= $realtime -pre_r_time;
      pre_r_time <=$realtime;
   end 
   
//////XINi period change///////////
   always @(posedge XINi or posedge PDRSTi)
   begin
      if(PDRSTi==1'b1)
          sample_XIN0 = 1'b0;
      else
      begin
      #0.001;
      if(((XIN_period-XIN_period_p)<=0.001)&&((XIN_period_p-XIN_period)<=0.001))
      begin
          #(XIN_period-0.002) sample_XIN0 = XINi;
      end
      end
   end
   
   always @(negedge XINi or posedge PDRSTi)
   begin
      if(PDRSTi==1'b1)
          sample_XIN1 = 1'b1;
      else
      begin
      if(((XIN_period-XIN_period_p)<=0.001)&&((XIN_period_p-XIN_period)<=0.001))
      begin
          #(XIN_period-0.001) sample_XIN1 = XINi;
      end
      end
   end  
   
   always @(posedge XINi)
   begin
      if(PDRSTi==1'b0)
      begin
      #0.001;
      if(((XIN_period-XIN_period_p)>0.001)||((XIN_period_p-XIN_period)>0.001))
          XIN_change_pre = ~XIN_change_pre;
      end
   end   
   
   always @(sample_XIN0 or sample_XIN1)
   begin
      if((sample_XIN0!==1'b0)||(sample_XIN1!=1'b1))
      begin
           XIN_change_post = ~XIN_change_post; 
      end
   end 
   
   always @(XIN_change_pre or XIN_change_post)
   begin
      XIN_change = ~XIN_change; 
   end 
      
//////////input unknow///////////////     
   assign unknow = (|Ni===1'bx) | (|Mi===1'bx) | (BPi===1'bx) | (PDRSTi===1'bx) 
                  | (|ODi===1'bx) | (RESETi===1'bx) | (XINi===1'bx)| (|PLL_TSTi===1'bx)| (OEi===1'bx);
      
   always @(posedge lkdt_en)
   begin
      if(unknow==1'b1) 
      begin          
	  $display("****************************************************");
	  $display("Error at %fns : One or more of the inputs unknown.",$realtime);
      end   
   end	

   wire unknow_in = unknow | (PLL_TSTi!=2'b00);      	              
////////////usage condition////////////////
   always @ (dvd or XIN_period or Mi_real or Ni_real)
   begin 
      if(dvd>=1)
      begin
          XIN_frq_divN = 1000 / (Ni_real * XIN_period);
          clk_frq_xNO =  Mi_real * 1000 / (Ni_real * XIN_period*2);                          
          cond[0] = (!((`XIN_N_min-XIN_frq_divN)>=0.001)) & (!((XIN_frq_divN-`XIN_N_max)>=0.001));
          cond[1] = (!((`CLK_OUT_min-clk_frq_xNO)>=0.001)) & (!((clk_frq_xNO-`CLK_OUT_max)>=0.001));
      end
      cond[2] = (dvd>=1);
   end 
   
   assign  clk_valid = (& cond);
   
   always @ (cond or BPi or lkdt_en) 
   begin 
    #1;
    if ((cond[2]==1'b0) && (BPi==1'b0) && (lkdt_en==1'b1)&&(unknow_in==1'b0))
    begin
	$display("****************************************************");
   	$display("Error at %f ns:  Violate rule (3) -   NO>=1;  NO =%5f",$realtime, dvd);  
    end      
    else begin
        if ((cond[0]==1'b0) && (BPi==1'b0) && (lkdt_en==1'b1)&&(unknow_in==1'b0))
    	begin
	    $display("****************************************************");
   	    $display("Error at %f ns: Violate rule (1) -   1MHz <= XIN/N <= 25MHz; XIN/N =%10fMHz ", $realtime, XIN_frq_divN); 
    	end
    	if ((cond[1]==1'b0) && (BPi==1'b0) && (lkdt_en==1'b1)&&(unknow_in==1'b0))
    	begin
	    $display("****************************************************");
   	    $display("Error at %f ns: Violate rule (2) -   100MHz <= CLK_OUTxNO <= 250MHz; CLK_OUTxNO =%10fMHz ", $realtime, clk_frq_xNO ); 
    	end
    end
   end   

/////////////output period/////////////////    
   always @(ODi or XIN_period or dvd or Ni_real or Mi_real)
   begin
      if((dvd>=1)&&(|ODi!==1'bx)&&(XIN_period<=XIN_period_max))
          clk_out_delay = ((Ni_real*XIN_period*dvd)/(Mi_real));  
      else
          clk_out_delay = 5;   
   end

/////////////re-lock /////////////////
   always @(Ni or Mi or PDRSTi or XIN_change or unknow_in)
   begin
          st_r=1'b0;
	  #1 st_r=1'b1;	  	  
   end
   
/////////////output clk /////////////////
   always @(posedge lkdt_en) 
   begin: syn_clk_out
      fork 
          begin
	      while(1) 
	         #(clk_out_delay) clk_out=~clk_out;
	  end
	  begin
	      @(Ni or Mi or PDRSTi or XIN_change or unknow_in)
	      begin
	         clk_out = 0;
		 disable syn_clk_out;     
	      end
	  end    
      join
   end 
   

   real TST_OUT_period;
   reg tst_outi; 
   initial 
   begin
      TST_OUT_period = 5;
      tst_outi = 0;
   end           
   
   always @(PLL_TSTi or XIN_period or Ni_real or Mi_real)
   begin
      if((Mi>=`M_min)&&(Ni>=`N_min)&&(PLL_TSTi==2'b00))
          TST_OUT_period = XIN_period * Ni_real;
      else if((Mi>=`M_min)&&(Ni>=`N_min)&&(PLL_TSTi==2'b11))
          TST_OUT_period = XIN_period * Mi_real; 
      else
          TST_OUT_period = 5;
   end 
     
   always 
      #(TST_OUT_period/2) tst_outi = ~tst_outi;   
   
   assign #(`LT_in-1,0) lkdt_en = st_r; 
   assign #`BP_delay xin_bypass = XINi;
   
   assign CLK_OUTi = RESETi ? 1'bx  :
                    (OEi!=1'b0) ? 1'b0 : 
		     BPi ? xin_bypass :
                     PDRSTi ? `CLK_OUT_in_SLEEP12 : 
		     ((PLL_TSTi==2'b01)|(PLL_TSTi==2'b10)) ? 1'bx :
		     (&PLL_TSTi) ? xin_bypass : 
		     unknow ? `unknown_value :
		     !lkdt_en ? `CLK_OUT_in_lock : 
		     clk_valid ? clk_out : 1'b0;
   
   assign TST_OUTi = ((OEi!=1'b0) | (RESETi!=1'b0) | (BPi!=1'b0) | (PDRSTi!=1'b0)) ? 1'bx :
                    ((Mi>=`M_min)&&(Ni>=`N_min)&&((PLL_TSTi==2'b00) | (PLL_TSTi==2'b11))) ? tst_outi :  1'bx;	
   
   assign LKDTi =  RESETi ? 1'bx : 
                   (OEi!=1'b0) ? 1'b0 :
                   PDRSTi ? `LKDT_in_SLEEP12 : 
		   ((PLL_TSTi==2'b01)|(PLL_TSTi==2'b10)) ? 1'bx :
		   (&PLL_TSTi) ? 1'bx : 
		  unknow ? `unknown_value : 
		  clk_valid ? lkdt_en : 1'b0;
              
endmodule
`endcelldefine  
