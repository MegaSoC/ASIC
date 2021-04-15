/*
    Copyright (c) 2021 SMIC
    Filename:      S018DP_RAM_DP_W512_B32_M4_BW.v
    IP code :      S018DP
    Version:       0.1.b
    CreateDate:    Apr 7, 2021

    Verilog Model for Dual-PORT 
    SMIC 0.18um G Logic Process

    Configuration: -instname S018DP_RAM_DP_W512_B32_M4_BW -rows 128 -bits 32 -mux 4 
    Redundancy: Off
    Bit-Write: On
*/

/* DISCLAIMER                                                                      */
/*                                                                                 */  
/*   SMIC hereby provides the quality information to you but makes no claims,      */
/* promises or guarantees about the accuracy, completeness, or adequacy of the     */
/* information herein. The information contained herein is provided on an "AS IS"  */
/* basis without any warranty, and SMIC assumes no obligation to provide support   */
/* of any kind or otherwise maintain the information.                              */  
/*   SMIC disclaims any representation that the information does not infringe any  */
/* intellectual property rights or proprietary rights of any third parties. SMIC   */
/* makes no other warranty, whether express, implied or statutory as to any        */
/* matter whatsoever, including but not limited to the accuracy or sufficiency of  */
/* any information or the merchantability and fitness for a particular purpose.    */
/* Neither SMIC nor any of its representatives shall be liable for any cause of    */
/* action incurred to connect to this service.                                     */  
/*                                                                                 */
/* STATEMENT OF USE AND CONFIDENTIALITY                                            */  
/*                                                                                 */  
/*   The following/attached material contains confidential and proprietary         */  
/* information of SMIC. This material is based upon information which SMIC         */  
/* considers reliable, but SMIC neither represents nor warrants that such          */
/* information is accurate or complete, and it must not be relied upon as such.    */
/* This information was prepared for informational purposes and is for the use     */
/* by SMIC's customer only. SMIC reserves the right to make changes in the         */  
/* information at any time without notice.                                         */  
/*   No part of this information may be reproduced, transmitted, transcribed,      */  
/* stored in a retrieval system, or translated into any human or computer          */ 
/* language, in any form or by any means, electronic, mechanical, magnetic,        */  
/* optical, chemical, manual, or otherwise, without the prior written consent of   */
/* SMIC. Any unauthorized use or disclosure of this material is strictly           */  
/* prohibited and may be unlawful. By accepting this material, the receiving       */  
/* party shall be deemed to have acknowledged, accepted, and agreed to be bound    */
/* by the foregoing limitations and restrictions. Thank you.                       */  
/*                                                                                 */  

`timescale 1ns/1ps
`celldefine

module S018DP_RAM_DP_W512_B32_M4_BW (
                         QA,
                         QB,
			  CLKA,
			  CLKB,
			  CENA,
			  CENB,
			  WENA,
			  WENB,
                          BWENA,
                          BWENB,
			  AA,
			  AB,
			  DA,
			  DB);


  parameter	Bits = 32;
  parameter	Word_Depth = 512;
  parameter	Add_Width = 9;
  parameter     Wen_Width = 32;
  parameter     Word_Pt = 1;

  output          [Bits-1:0]      	QA;
  output          [Bits-1:0]      	QB;
  input		   		CLKA;
  input		   		CLKB;
  input		   		CENA;
  input		   		CENB;
  input		   		WENA;
  input		   		WENB;
  input [Wen_Width-1:0]         BWENA;
  input [Wen_Width-1:0]         BWENB;
  input	[Add_Width-1:0] 	AA;
  input	[Add_Width-1:0] 	AB;
  input	[Bits-1:0] 		DA;
  input	[Bits-1:0] 		DB;

  wire [Bits-1:0] 	QA_int;
  wire [Bits-1:0] 	QB_int;
  wire [Add_Width-1:0] 	AA_int;
  wire [Add_Width-1:0] 	AB_int;
  wire                 	CLKA_int;
  wire                 	CLKB_int;
  wire                 	CENA_int;
  wire                 	CENB_int;
  wire                 	WENA_int;
  wire                 	WENB_int;
  wire [Wen_Width-1:0]  BWENA_int;
  wire [Wen_Width-1:0]  BWENB_int;
  wire [Bits-1:0] 	DA_int;
  wire [Bits-1:0] 	DB_int;

  reg  [Bits-1:0] 	QA_latched;
  reg  [Bits-1:0] 	QB_latched;
  reg  [Add_Width-1:0] 	AA_latched;
  reg  [Add_Width-1:0] 	AB_latched;
  reg  [Bits-1:0] 	DA_latched;
  reg  [Bits-1:0] 	DB_latched;
  reg                  	CENA_latched;
  reg                  	CENB_latched;
  reg                  	LAST_CLKA;
  reg                  	LAST_CLKB;
  reg                  	WENA_latched;
  reg                  	WENB_latched;
  reg [Wen_Width-1:0]  BWENA_latched;
  reg [Wen_Width-1:0]  BWENB_latched;

  reg 			AA0_flag;
  reg 			AA1_flag;
  reg 			AA2_flag;
  reg 			AA3_flag;
  reg 			AA4_flag;
  reg 			AA5_flag;
  reg 			AA6_flag;
  reg 			AA7_flag;
  reg 			AA8_flag;
  reg 			AB0_flag;
  reg 			AB1_flag;
  reg 			AB2_flag;
  reg 			AB3_flag;
  reg 			AB4_flag;
  reg 			AB5_flag;
  reg 			AB6_flag;
  reg 			AB7_flag;
  reg 			AB8_flag;

  reg                	CENA_flag;
  reg                	CENB_flag;
  reg                   CLKA_CYC_flag;
  reg                   CLKB_CYC_flag;
  reg                   CLKA_H_flag;
  reg                   CLKB_H_flag;
  reg                   CLKA_L_flag;
  reg                   CLKB_L_flag;

  reg 			DA0_flag;
  reg 			DA1_flag;
  reg 			DA2_flag;
  reg 			DA3_flag;
  reg 			DA4_flag;
  reg 			DA5_flag;
  reg 			DA6_flag;
  reg 			DA7_flag;
  reg 			DA8_flag;
  reg 			DA9_flag;
  reg 			DA10_flag;
  reg 			DA11_flag;
  reg 			DA12_flag;
  reg 			DA13_flag;
  reg 			DA14_flag;
  reg 			DA15_flag;
  reg 			DA16_flag;
  reg 			DA17_flag;
  reg 			DA18_flag;
  reg 			DA19_flag;
  reg 			DA20_flag;
  reg 			DA21_flag;
  reg 			DA22_flag;
  reg 			DA23_flag;
  reg 			DA24_flag;
  reg 			DA25_flag;
  reg 			DA26_flag;
  reg 			DA27_flag;
  reg 			DA28_flag;
  reg 			DA29_flag;
  reg 			DA30_flag;
  reg 			DA31_flag;
  reg 			DB0_flag;
  reg 			DB1_flag;
  reg 			DB2_flag;
  reg 			DB3_flag;
  reg 			DB4_flag;
  reg 			DB5_flag;
  reg 			DB6_flag;
  reg 			DB7_flag;
  reg 			DB8_flag;
  reg 			DB9_flag;
  reg 			DB10_flag;
  reg 			DB11_flag;
  reg 			DB12_flag;
  reg 			DB13_flag;
  reg 			DB14_flag;
  reg 			DB15_flag;
  reg 			DB16_flag;
  reg 			DB17_flag;
  reg 			DB18_flag;
  reg 			DB19_flag;
  reg 			DB20_flag;
  reg 			DB21_flag;
  reg 			DB22_flag;
  reg 			DB23_flag;
  reg 			DB24_flag;
  reg 			DB25_flag;
  reg 			DB26_flag;
  reg 			DB27_flag;
  reg 			DB28_flag;
  reg 			DB29_flag;
  reg 			DB30_flag;
  reg 			DB31_flag;

reg                   WENA_flag; 
reg                   WENB_flag; 

reg 	              BWENA0_flag;
reg 	              BWENB0_flag;
reg 	              BWENA1_flag;
reg 	              BWENB1_flag;
reg 	              BWENA2_flag;
reg 	              BWENB2_flag;
reg 	              BWENA3_flag;
reg 	              BWENB3_flag;
reg 	              BWENA4_flag;
reg 	              BWENB4_flag;
reg 	              BWENA5_flag;
reg 	              BWENB5_flag;
reg 	              BWENA6_flag;
reg 	              BWENB6_flag;
reg 	              BWENA7_flag;
reg 	              BWENB7_flag;
reg 	              BWENA8_flag;
reg 	              BWENB8_flag;
reg 	              BWENA9_flag;
reg 	              BWENB9_flag;
reg 	              BWENA10_flag;
reg 	              BWENB10_flag;
reg 	              BWENA11_flag;
reg 	              BWENB11_flag;
reg 	              BWENA12_flag;
reg 	              BWENB12_flag;
reg 	              BWENA13_flag;
reg 	              BWENB13_flag;
reg 	              BWENA14_flag;
reg 	              BWENB14_flag;
reg 	              BWENA15_flag;
reg 	              BWENB15_flag;
reg 	              BWENA16_flag;
reg 	              BWENB16_flag;
reg 	              BWENA17_flag;
reg 	              BWENB17_flag;
reg 	              BWENA18_flag;
reg 	              BWENB18_flag;
reg 	              BWENA19_flag;
reg 	              BWENB19_flag;
reg 	              BWENA20_flag;
reg 	              BWENB20_flag;
reg 	              BWENA21_flag;
reg 	              BWENB21_flag;
reg 	              BWENA22_flag;
reg 	              BWENB22_flag;
reg 	              BWENA23_flag;
reg 	              BWENB23_flag;
reg 	              BWENA24_flag;
reg 	              BWENB24_flag;
reg 	              BWENA25_flag;
reg 	              BWENB25_flag;
reg 	              BWENA26_flag;
reg 	              BWENB26_flag;
reg 	              BWENA27_flag;
reg 	              BWENB27_flag;
reg 	              BWENA28_flag;
reg 	              BWENB28_flag;
reg 	              BWENA29_flag;
reg 	              BWENB29_flag;
reg 	              BWENA30_flag;
reg 	              BWENB30_flag;
reg 	              BWENA31_flag;
reg 	              BWENB31_flag;
reg [Wen_Width-1:0]   BWENA_flag;
reg [Wen_Width-1:0]   BWENB_flag;
reg                   VIOA_flag;
reg                   VIOB_flag;
reg                   LAST_VIOA_flag;
reg                   LAST_VIOB_flag;

reg [Add_Width-1:0]   AA_flag;
reg [Add_Width-1:0]   AB_flag;
reg [Bits-1:0]        DA_flag;
reg [Bits-1:0]        DB_flag;

 reg                   LAST_CENA_flag;
 reg                   LAST_CENB_flag;
 reg                   LAST_WENA_flag;
 reg                   LAST_WENB_flag;
 reg [Wen_Width-1:0]  LAST_BWENA_flag;
 reg [Wen_Width-1:0]  LAST_BWENB_flag;

 reg [Add_Width-1:0]   LAST_AA_flag;
 reg [Add_Width-1:0]   LAST_AB_flag;
 reg [Bits-1:0]        LAST_DA_flag;
 reg [Bits-1:0]        LAST_DB_flag;

  reg                   LAST_CLKA_CYC_flag;
  reg                   LAST_CLKB_CYC_flag;
  reg                   LAST_CLKA_H_flag;
  reg                   LAST_CLKB_H_flag;
  reg                   LAST_CLKA_L_flag;
  reg                   LAST_CLKB_L_flag;
  reg [Bits-1:0]        data_tmpa;
  reg [Bits-1:0]        data_tmpb;
  wire                  CEA_flag;
  wire                  CEB_flag;
  wire                    clkconfA_flag;
  wire                    clkconfB_flag;
  wire                    clkconf_flag;

  wire 	                WRA0_flag;
  wire 	                WRB0_flag;
  wire 	                WRA1_flag;
  wire 	                WRB1_flag;
  wire 	                WRA2_flag;
  wire 	                WRB2_flag;
  wire 	                WRA3_flag;
  wire 	                WRB3_flag;
  wire 	                WRA4_flag;
  wire 	                WRB4_flag;
  wire 	                WRA5_flag;
  wire 	                WRB5_flag;
  wire 	                WRA6_flag;
  wire 	                WRB6_flag;
  wire 	                WRA7_flag;
  wire 	                WRB7_flag;
  wire 	                WRA8_flag;
  wire 	                WRB8_flag;
  wire 	                WRA9_flag;
  wire 	                WRB9_flag;
  wire 	                WRA10_flag;
  wire 	                WRB10_flag;
  wire 	                WRA11_flag;
  wire 	                WRB11_flag;
  wire 	                WRA12_flag;
  wire 	                WRB12_flag;
  wire 	                WRA13_flag;
  wire 	                WRB13_flag;
  wire 	                WRA14_flag;
  wire 	                WRB14_flag;
  wire 	                WRA15_flag;
  wire 	                WRB15_flag;
  wire 	                WRA16_flag;
  wire 	                WRB16_flag;
  wire 	                WRA17_flag;
  wire 	                WRB17_flag;
  wire 	                WRA18_flag;
  wire 	                WRB18_flag;
  wire 	                WRA19_flag;
  wire 	                WRB19_flag;
  wire 	                WRA20_flag;
  wire 	                WRB20_flag;
  wire 	                WRA21_flag;
  wire 	                WRB21_flag;
  wire 	                WRA22_flag;
  wire 	                WRB22_flag;
  wire 	                WRA23_flag;
  wire 	                WRB23_flag;
  wire 	                WRA24_flag;
  wire 	                WRB24_flag;
  wire 	                WRA25_flag;
  wire 	                WRB25_flag;
  wire 	                WRA26_flag;
  wire 	                WRB26_flag;
  wire 	                WRA27_flag;
  wire 	                WRB27_flag;
  wire 	                WRA28_flag;
  wire 	                WRB28_flag;
  wire 	                WRA29_flag;
  wire 	                WRB29_flag;
  wire 	                WRA30_flag;
  wire 	                WRB30_flag;
  wire 	                WRA31_flag;
  wire 	                WRB31_flag;

  reg    [Bits-1:0] 	mem_array[Word_Depth-1:0];

  integer      i,j,wenn,lb,hb;
  integer      n;

 buf qa_buf[Bits-1:0] (QA, QA_int);
  buf qb_buf[Bits-1:0] (QB, QB_int);
  buf (CLKA_int, CLKA);
  buf (CLKB_int, CLKB);
  buf (CENA_int, CENA);
  buf (CENB_int, CENB);
  buf (WENA_int, WENA);
  buf (WENB_int, WENB);
  buf bwena_buf[Wen_Width-1:0] (BWENA_int, BWENA);
  buf bwenb_buf[Wen_Width-1:0] (BWENB_int, BWENB);
  buf aa_buf[Add_Width-1:0] (AA_int, AA);
  buf ab_buf[Add_Width-1:0] (AB_int, AB);
  buf da_buf[Bits-1:0] (DA_int, DA);   
  buf db_buf[Bits-1:0] (DB_int, DB);   

  assign QA_int=QA_latched;
  assign QB_int=QB_latched;
  assign CEA_flag=!CENA_int;
  assign CEB_flag=!CENB_int;

  assign WRA0_flag=(!CENA_int && !WENA_int && !BWENA_int[0]);
  assign WRB0_flag=(!CENB_int && !WENB_int && !BWENB_int[0]);
  assign WRA1_flag=(!CENA_int && !WENA_int && !BWENA_int[1]);
  assign WRB1_flag=(!CENB_int && !WENB_int && !BWENB_int[1]);
  assign WRA2_flag=(!CENA_int && !WENA_int && !BWENA_int[2]);
  assign WRB2_flag=(!CENB_int && !WENB_int && !BWENB_int[2]);
  assign WRA3_flag=(!CENA_int && !WENA_int && !BWENA_int[3]);
  assign WRB3_flag=(!CENB_int && !WENB_int && !BWENB_int[3]);
  assign WRA4_flag=(!CENA_int && !WENA_int && !BWENA_int[4]);
  assign WRB4_flag=(!CENB_int && !WENB_int && !BWENB_int[4]);
  assign WRA5_flag=(!CENA_int && !WENA_int && !BWENA_int[5]);
  assign WRB5_flag=(!CENB_int && !WENB_int && !BWENB_int[5]);
  assign WRA6_flag=(!CENA_int && !WENA_int && !BWENA_int[6]);
  assign WRB6_flag=(!CENB_int && !WENB_int && !BWENB_int[6]);
  assign WRA7_flag=(!CENA_int && !WENA_int && !BWENA_int[7]);
  assign WRB7_flag=(!CENB_int && !WENB_int && !BWENB_int[7]);
  assign WRA8_flag=(!CENA_int && !WENA_int && !BWENA_int[8]);
  assign WRB8_flag=(!CENB_int && !WENB_int && !BWENB_int[8]);
  assign WRA9_flag=(!CENA_int && !WENA_int && !BWENA_int[9]);
  assign WRB9_flag=(!CENB_int && !WENB_int && !BWENB_int[9]);
  assign WRA10_flag=(!CENA_int && !WENA_int && !BWENA_int[10]);
  assign WRB10_flag=(!CENB_int && !WENB_int && !BWENB_int[10]);
  assign WRA11_flag=(!CENA_int && !WENA_int && !BWENA_int[11]);
  assign WRB11_flag=(!CENB_int && !WENB_int && !BWENB_int[11]);
  assign WRA12_flag=(!CENA_int && !WENA_int && !BWENA_int[12]);
  assign WRB12_flag=(!CENB_int && !WENB_int && !BWENB_int[12]);
  assign WRA13_flag=(!CENA_int && !WENA_int && !BWENA_int[13]);
  assign WRB13_flag=(!CENB_int && !WENB_int && !BWENB_int[13]);
  assign WRA14_flag=(!CENA_int && !WENA_int && !BWENA_int[14]);
  assign WRB14_flag=(!CENB_int && !WENB_int && !BWENB_int[14]);
  assign WRA15_flag=(!CENA_int && !WENA_int && !BWENA_int[15]);
  assign WRB15_flag=(!CENB_int && !WENB_int && !BWENB_int[15]);
  assign WRA16_flag=(!CENA_int && !WENA_int && !BWENA_int[16]);
  assign WRB16_flag=(!CENB_int && !WENB_int && !BWENB_int[16]);
  assign WRA17_flag=(!CENA_int && !WENA_int && !BWENA_int[17]);
  assign WRB17_flag=(!CENB_int && !WENB_int && !BWENB_int[17]);
  assign WRA18_flag=(!CENA_int && !WENA_int && !BWENA_int[18]);
  assign WRB18_flag=(!CENB_int && !WENB_int && !BWENB_int[18]);
  assign WRA19_flag=(!CENA_int && !WENA_int && !BWENA_int[19]);
  assign WRB19_flag=(!CENB_int && !WENB_int && !BWENB_int[19]);
  assign WRA20_flag=(!CENA_int && !WENA_int && !BWENA_int[20]);
  assign WRB20_flag=(!CENB_int && !WENB_int && !BWENB_int[20]);
  assign WRA21_flag=(!CENA_int && !WENA_int && !BWENA_int[21]);
  assign WRB21_flag=(!CENB_int && !WENB_int && !BWENB_int[21]);
  assign WRA22_flag=(!CENA_int && !WENA_int && !BWENA_int[22]);
  assign WRB22_flag=(!CENB_int && !WENB_int && !BWENB_int[22]);
  assign WRA23_flag=(!CENA_int && !WENA_int && !BWENA_int[23]);
  assign WRB23_flag=(!CENB_int && !WENB_int && !BWENB_int[23]);
  assign WRA24_flag=(!CENA_int && !WENA_int && !BWENA_int[24]);
  assign WRB24_flag=(!CENB_int && !WENB_int && !BWENB_int[24]);
  assign WRA25_flag=(!CENA_int && !WENA_int && !BWENA_int[25]);
  assign WRB25_flag=(!CENB_int && !WENB_int && !BWENB_int[25]);
  assign WRA26_flag=(!CENA_int && !WENA_int && !BWENA_int[26]);
  assign WRB26_flag=(!CENB_int && !WENB_int && !BWENB_int[26]);
  assign WRA27_flag=(!CENA_int && !WENA_int && !BWENA_int[27]);
  assign WRB27_flag=(!CENB_int && !WENB_int && !BWENB_int[27]);
  assign WRA28_flag=(!CENA_int && !WENA_int && !BWENA_int[28]);
  assign WRB28_flag=(!CENB_int && !WENB_int && !BWENB_int[28]);
  assign WRA29_flag=(!CENA_int && !WENA_int && !BWENA_int[29]);
  assign WRB29_flag=(!CENB_int && !WENB_int && !BWENB_int[29]);
  assign WRA30_flag=(!CENA_int && !WENA_int && !BWENA_int[30]);
  assign WRB30_flag=(!CENB_int && !WENB_int && !BWENB_int[30]);
  assign WRA31_flag=(!CENA_int && !WENA_int && !BWENA_int[31]);
  assign WRB31_flag=(!CENB_int && !WENB_int && !BWENB_int[31]);
  assign clkconfA_flag=(AA_int===AB_latched) && (CENA_int!==1'b1) && (CENB_latched!==1'b1);
  assign clkconfB_flag=(AB_int===AA_latched) && (CENB_int!==1'b1) && (CENA_latched!==1'b1);
  assign clkconf_flag=(AA_int===AB_int) && (CENA_int!==1'b1) && (CENB_int!==1'b1);

   always @(CLKA_int)
    begin
      casez({LAST_CLKA, CLKA_int})
        2'b01: begin
          CENA_latched = CENA_int;
          WENA_latched = WENA_int;
          BWENA_latched = BWENA_int;
          AA_latched = AA_int;
          DA_latched = DA_int;
          rw_memA;
        end
        2'b10,
        2'bx?,
        2'b00,
        2'b11: ;
        2'b?x: begin
	  for(i=0;i<Word_Depth;i=i+1)
    	    mem_array[i]={Bits{1'bx}};
    	  QA_latched={Bits{1'bx}};
          rw_memA;
          end
      endcase
    LAST_CLKA=CLKA_int;
   end

always @(CLKB_int)
    begin
      casez({LAST_CLKB, CLKB_int})
        2'b01: begin
          CENB_latched = CENB_int;
          WENB_latched = WENB_int;
          BWENB_latched = BWENB_int;
          AB_latched = AB_int;
          DB_latched = DB_int;
          rw_memB;
        end
        2'b10,
        2'bx?,
        2'b00,
        2'b11: ;
        2'b?x: begin
          for(i=0;i<Word_Depth;i=i+1)
    	    mem_array[i]={Bits{1'bx}};
QB_latched={Bits{1'bx}};
          rw_memA;
          end
      endcase
    LAST_CLKB=CLKB_int;
   end


  always @(CENA_flag
           	or WENA_flag
		or BWENA0_flag
		or BWENA1_flag
		or BWENA2_flag
		or BWENA3_flag
		or BWENA4_flag
		or BWENA5_flag
		or BWENA6_flag
		or BWENA7_flag
		or BWENA8_flag
		or BWENA9_flag
		or BWENA10_flag
		or BWENA11_flag
		or BWENA12_flag
		or BWENA13_flag
		or BWENA14_flag
		or BWENA15_flag
		or BWENA16_flag
		or BWENA17_flag
		or BWENA18_flag
		or BWENA19_flag
		or BWENA20_flag
		or BWENA21_flag
		or BWENA22_flag
		or BWENA23_flag
		or BWENA24_flag
		or BWENA25_flag
		or BWENA26_flag
		or BWENA27_flag
		or BWENA28_flag
		or BWENA29_flag
		or BWENA30_flag
		or BWENA31_flag
		or AA0_flag
		or AA1_flag
		or AA2_flag
		or AA3_flag
		or AA4_flag
		or AA5_flag
		or AA6_flag
		or AA7_flag
		or AA8_flag
		or DA0_flag
		or DA1_flag
		or DA2_flag
		or DA3_flag
		or DA4_flag
		or DA5_flag
		or DA6_flag
		or DA7_flag
		or DA8_flag
		or DA9_flag
		or DA10_flag
		or DA11_flag
		or DA12_flag
		or DA13_flag
		or DA14_flag
		or DA15_flag
		or DA16_flag
		or DA17_flag
		or DA18_flag
		or DA19_flag
		or DA20_flag
		or DA21_flag
		or DA22_flag
		or DA23_flag
		or DA24_flag
		or DA25_flag
		or DA26_flag
		or DA27_flag
		or DA28_flag
		or DA29_flag
		or DA30_flag
		or DA31_flag
           	or CLKA_CYC_flag
           	or CLKA_H_flag
           	or CLKA_L_flag
                or VIOA_flag)
    begin
      update_flag_busA;
      CENA_latched = (CENA_flag!==LAST_CENA_flag) ? 1'bx : CENA_latched ;
      WENA_latched = (WENA_flag!==LAST_WENA_flag) ? 1'bx : WENA_latched ;
      for (n=0; n<Wen_Width; n=n+1)
      BWENA_latched[n] = (BWENA_flag[n]!==LAST_BWENA_flag[n]) ? 1'bx : BWENA_latched[n] ;
      for (n=0; n<Add_Width; n=n+1)
      AA_latched[n] = (AA_flag[n]!==LAST_AA_flag[n]) ? 1'bx : AA_latched[n] ;
      for (n=0; n<Bits; n=n+1)
      DA_latched[n] = (DA_flag[n]!==LAST_DA_flag[n]) ? 1'bx : DA_latched[n] ;
      LAST_CENA_flag = CENA_flag;
      LAST_WENA_flag = WENA_flag;
      LAST_BWENA_flag = BWENA_flag;
      LAST_AA_flag = AA_flag;
      LAST_DA_flag = DA_flag;
      LAST_CLKA_CYC_flag = CLKA_CYC_flag;
      LAST_CLKA_H_flag = CLKA_H_flag;
      LAST_CLKA_L_flag = CLKA_L_flag;
      if(VIOA_flag!==LAST_VIOA_flag)
      begin
          if(WENB_latched===1'b1)
            QB_latched={Bits{1'bx}};
          else
            begin
              if(WENA_latched===1'b1)
                QA_latched={Bits{1'bx}};
              else
                begin
                  if(^(AA_latched)===1'bx)
                    for(i=0;i<Word_Depth;i=i+1)
                      mem_array[i]={Bits{1'bx}};
                  else
                    mem_array[AA_latched]={Bits{1'bx}};
                end
            end
          LAST_VIOA_flag=VIOA_flag;
        end
      else
      rw_memA;
   end

always @(CENB_flag
           	or WENB_flag
		or BWENB0_flag
		or BWENB1_flag
		or BWENB2_flag
		or BWENB3_flag
		or BWENB4_flag
		or BWENB5_flag
		or BWENB6_flag
		or BWENB7_flag
		or BWENB8_flag
		or BWENB9_flag
		or BWENB10_flag
		or BWENB11_flag
		or BWENB12_flag
		or BWENB13_flag
		or BWENB14_flag
		or BWENB15_flag
		or BWENB16_flag
		or BWENB17_flag
		or BWENB18_flag
		or BWENB19_flag
		or BWENB20_flag
		or BWENB21_flag
		or BWENB22_flag
		or BWENB23_flag
		or BWENB24_flag
		or BWENB25_flag
		or BWENB26_flag
		or BWENB27_flag
		or BWENB28_flag
		or BWENB29_flag
		or BWENB30_flag
		or BWENB31_flag
		or AB0_flag
		or AB1_flag
		or AB2_flag
		or AB3_flag
		or AB4_flag
		or AB5_flag
		or AB6_flag
		or AB7_flag
		or AB8_flag
		or DB0_flag
		or DB1_flag
		or DB2_flag
		or DB3_flag
		or DB4_flag
		or DB5_flag
		or DB6_flag
		or DB7_flag
		or DB8_flag
		or DB9_flag
		or DB10_flag
		or DB11_flag
		or DB12_flag
		or DB13_flag
		or DB14_flag
		or DB15_flag
		or DB16_flag
		or DB17_flag
		or DB18_flag
		or DB19_flag
		or DB20_flag
		or DB21_flag
		or DB22_flag
		or DB23_flag
		or DB24_flag
		or DB25_flag
		or DB26_flag
		or DB27_flag
		or DB28_flag
		or DB29_flag
		or DB30_flag
		or DB31_flag
           	or CLKB_CYC_flag
           	or CLKB_H_flag
           	or CLKB_L_flag
                or VIOB_flag)
begin
      update_flag_busB;
      CENB_latched = (CENB_flag!==LAST_CENB_flag) ? 1'bx : CENB_latched ;
      WENB_latched = (WENB_flag!==LAST_WENB_flag) ? 1'bx : WENB_latched ;
      for (n=0; n<Wen_Width; n=n+1)
      BWENB_latched[n] = (BWENB_flag[n]!==LAST_BWENB_flag[n]) ? 1'bx : BWENB_latched[n] ;
      for (n=0; n<Add_Width; n=n+1)
      AB_latched[n] = (AB_flag[n]!==LAST_AB_flag[n]) ? 1'bx : AB_latched[n] ;
      for (n=0; n<Bits; n=n+1)
      DB_latched[n] = (DB_flag[n]!==LAST_DB_flag[n]) ? 1'bx : DB_latched[n] ;
      LAST_CENB_flag = CENB_flag;
      LAST_WENB_flag = WENB_flag;
      LAST_BWENB_flag = BWENB_flag;
      LAST_AB_flag = AB_flag;
      LAST_DB_flag = DB_flag;
      LAST_CLKB_CYC_flag = CLKB_CYC_flag;
      LAST_CLKB_H_flag = CLKB_H_flag;
      LAST_CLKB_L_flag = CLKB_L_flag;
      if(VIOB_flag!==LAST_VIOB_flag)
        begin
          if(WENA_latched===1'b1)
            QA_latched={Bits{1'bx}};
          else
            begin
              if(WENB_latched===1'b1)
                QB_latched={Bits{1'bx}};
              else
                begin
                  if(^(AB_latched)===1'bx)
                    for(i=0;i<Word_Depth;i=i+1)
                      mem_array[i]={Bits{1'bx}};
                  else
                    mem_array[AB_latched]={Bits{1'bx}};
                end
            end
          LAST_VIOB_flag=VIOB_flag;
        end
      else
      rw_memB;
   end

  task rw_memA;
    begin
      if(CENA_latched==1'b0)
        begin
          if (WENA_latched==1'b1)
            begin
              if(^(AA_latched)==1'bx)
                QA_latched={Bits{1'bx}};
              else
                QA_latched=mem_array[AA_latched];
            end
          else if (WENA_latched==1'b0)
          begin
            for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
              begin
                lb=wenn*Word_Pt;
                if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                else hb=lb+Word_Pt-1;
                if (BWENA_latched[wenn]==1'b1)
                  begin
                    if(^(AA_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) QA_latched[i]=1'bx;
                    else
                      begin
                      data_tmpa=mem_array[AA_latched];
                      for (i=lb; i<=hb; i=i+1) QA_latched[i]=data_tmpa[i];
                      end
                  end
                else if (BWENA_latched[wenn]==1'b0)
                  begin
                    if (^(AA_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpa=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpa[j]=1'bx;
                            mem_array[i]=data_tmpa;
                          end
                        for (i=lb; i<=hb; i=i+1) QA_latched[i]=1'bx;
                      end
                    else
                      begin
                        data_tmpa=mem_array[AA_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpa[i]=DA_latched[i];
                        mem_array[AA_latched]=data_tmpa;
                        for (i=lb; i<=hb; i=i+1) QA_latched[i]=data_tmpa[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) QA_latched[i]=1'bx;
                    if (^(AA_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpa=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpa[j]=1'bx;
                            mem_array[i]=data_tmpa;
                          end
                      end
                    else
                      begin
                        data_tmpa=mem_array[AA_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpa[i]=1'bx;
                        mem_array[AA_latched]=data_tmpa;
                      end
                 end
               end
             end
           else
             begin
               for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
               begin
                 lb=wenn*Word_Pt;
                 if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                 else hb=lb+Word_Pt-1;
                 if (BWENA_latched[wenn]==1'b1)
                  begin
                    if(^(AA_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) QA_latched[i]=1'bx;
                    else
                      begin
                      data_tmpa=mem_array[AA_latched];
                      for (i=lb; i<=hb; i=i+1) QA_latched[i]=data_tmpa[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) QA_latched[i]=1'bx;
                    if (^(AA_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpa=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpa[j]=1'bx;
                            mem_array[i]=data_tmpa;
                          end
                      end
                    else
                      begin
                        data_tmpa=mem_array[AA_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpa[i]=1'bx;
                        mem_array[AA_latched]=data_tmpa;
                      end
                 end
               end
             end
           end
         else if (CENA_latched==1'bx)
           begin
             for (wenn=0;wenn<Wen_Width;wenn=wenn+1)
            begin
              lb=wenn*Word_Pt;
              if ((lb+Word_Pt)>=Bits) hb=Bits-1;
              else hb=lb+Word_Pt-1;
              if(WENA_latched==1'b1 || BWENA_latched[wenn]==1'b1)
                for (i=lb;i<=hb;i=i+1) QA_latched[i]=1'bx;
              else
                begin
                  for (i=lb;i<=hb;i=i+1) QA_latched[i]=1'bx;
                  if(^(AA_latched)==1'bx)
                    begin
                      for (i=0;i<Word_Depth;i=i+1)
                        begin
                          data_tmpa=mem_array[i];
                          for (j=lb;j<=hb;j=j+1) data_tmpa[j]=1'bx;
                          mem_array[i]=data_tmpa;
                        end
                    end
                  else
                    begin
                      data_tmpa=mem_array[AA_latched];
                      for (i=lb;i<=hb;i=i+1) data_tmpa[i]=1'bx;
                      mem_array[AA_latched]=data_tmpa;
                    end
                end
            end
        end
    end
  endtask
  
task rw_memB;
    begin
      if(CENB_latched==1'b0)
        begin
          if (WENB_latched==1'b1)
            begin
              if(^(AB_latched)==1'bx)
                QB_latched={Bits{1'bx}};
              else
                QB_latched=mem_array[AB_latched];
            end
          else if (WENB_latched==1'b0)
          begin
            for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
              begin
                lb=wenn*Word_Pt;
                if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                else hb=lb+Word_Pt-1;
                if (BWENB_latched[wenn]==1'b1)
                  begin
                    if(^(AB_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) QB_latched[i]=1'bx;
                    else
                      begin
                      data_tmpb=mem_array[AB_latched];
                      for (i=lb; i<=hb; i=i+1) QB_latched[i]=data_tmpb[i];
                      end
                  end
                else if (BWENB_latched[wenn]==1'b0)
                  begin
                    if (^(AB_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpb=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpb[j]=1'bx;
                            mem_array[i]=data_tmpb;
                          end
                        for (i=lb; i<=hb; i=i+1) QB_latched[i]=1'bx;
                      end
                    else
                      begin
                        data_tmpb=mem_array[AB_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpb[i]=DB_latched[i];
                        mem_array[AB_latched]=data_tmpb;
                        for (i=lb; i<=hb; i=i+1) QB_latched[i]=data_tmpb[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) QB_latched[i]=1'bx;
                    if (^(AB_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpb=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpb[j]=1'bx;
                            mem_array[i]=data_tmpb;
                          end
                      end
                    else
                      begin
                        data_tmpb=mem_array[AB_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpb[i]=1'bx;
                        mem_array[AB_latched]=data_tmpb;
                      end
                 end
               end
             end
           else
             begin
               for (wenn=0; wenn<Wen_Width; wenn=wenn+1)
               begin
                 lb=wenn*Word_Pt;
                 if ( (lb+Word_Pt) >= Bits) hb=Bits-1;
                 else hb=lb+Word_Pt-1;
                 if (BWENB_latched[wenn]==1'b1)
                  begin
                    if(^(AB_latched)==1'bx)
                      for (i=lb; i<=hb; i=i+1) QB_latched[i]=1'bx;
                    else
                      begin
                      data_tmpb=mem_array[AB_latched];
                      for (i=lb; i<=hb; i=i+1) QB_latched[i]=data_tmpb[i];
                      end
                  end
                else
                  begin
                    for (i=lb; i<=hb;i=i+1) QB_latched[i]=1'bx;
                    if (^(AB_latched)==1'bx)
                      begin
                        for (i=0; i<Word_Depth; i=i+1)
                          begin
                            data_tmpb=mem_array[i];
                            for (j=lb; j<=hb; j=j+1) data_tmpb[j]=1'bx;
                            mem_array[i]=data_tmpb;
                          end
                      end
                    else
                      begin
                        data_tmpb=mem_array[AB_latched];
                        for (i=lb; i<=hb; i=i+1) data_tmpb[i]=1'bx;
                        mem_array[AB_latched]=data_tmpb;
                      end
                 end
               end
             end
           end
         else if (CENB_latched==1'bx)
           begin
             for (wenn=0;wenn<Wen_Width;wenn=wenn+1)
            begin
              lb=wenn*Word_Pt;
              if ((lb+Word_Pt)>=Bits) hb=Bits-1;
              else hb=lb+Word_Pt-1;
              if(WENB_latched==1'b1 || BWENB_latched[wenn]==1'b1)
                for (i=lb;i<=hb;i=i+1) QB_latched[i]=1'bx;
              else
                begin
                  for (i=lb;i<=hb;i=i+1) QB_latched[i]=1'bx;
                  if(^(AB_latched)==1'bx)
                    begin
                      for (i=0;i<Word_Depth;i=i+1)
                        begin
                          data_tmpb=mem_array[i];
                          for (j=lb;j<=hb;j=j+1) data_tmpb[j]=1'bx;
                          mem_array[i]=data_tmpb;
                        end
                    end
                  else
                    begin
                      data_tmpb=mem_array[AB_latched];
                      for (i=lb;i<=hb;i=i+1) data_tmpb[i]=1'bx;
                      mem_array[AB_latched]=data_tmpb;
                    end
                end
            end
        end
    end
  endtask

   task x_mem;
   begin
     for(i=0;i<Word_Depth;i=i+1)
     mem_array[i]={Bits{1'bx}};
   end
   endtask

  task update_flag_busA;
  begin
    BWENA_flag = {
                BWENA31_flag,
                BWENA30_flag,
                BWENA29_flag,
                BWENA28_flag,
                BWENA27_flag,
                BWENA26_flag,
                BWENA25_flag,
                BWENA24_flag,
                BWENA23_flag,
                BWENA22_flag,
                BWENA21_flag,
                BWENA20_flag,
                BWENA19_flag,
                BWENA18_flag,
                BWENA17_flag,
                BWENA16_flag,
                BWENA15_flag,
                BWENA14_flag,
                BWENA13_flag,
                BWENA12_flag,
                BWENA11_flag,
                BWENA10_flag,
                BWENA9_flag,
                BWENA8_flag,
                BWENA7_flag,
                BWENA6_flag,
                BWENA5_flag,
                BWENA4_flag,
                BWENA3_flag,
                BWENA2_flag,
                BWENA1_flag,
                BWENA0_flag};
    AA_flag = {
		AA8_flag,
		AA7_flag,
		AA6_flag,
		AA5_flag,
		AA4_flag,
		AA3_flag,
		AA2_flag,
		AA1_flag,
                AA0_flag};
    DA_flag = {
		DA31_flag,
		DA30_flag,
		DA29_flag,
		DA28_flag,
		DA27_flag,
		DA26_flag,
		DA25_flag,
		DA24_flag,
		DA23_flag,
		DA22_flag,
		DA21_flag,
		DA20_flag,
		DA19_flag,
		DA18_flag,
		DA17_flag,
		DA16_flag,
		DA15_flag,
		DA14_flag,
		DA13_flag,
		DA12_flag,
		DA11_flag,
		DA10_flag,
		DA9_flag,
		DA8_flag,
		DA7_flag,
		DA6_flag,
		DA5_flag,
		DA4_flag,
		DA3_flag,
		DA2_flag,
		DA1_flag,
                DA0_flag};
   end
   endtask

  task update_flag_busB;
  begin
    BWENB_flag = {
                BWENB31_flag,
                BWENB30_flag,
                BWENB29_flag,
                BWENB28_flag,
                BWENB27_flag,
                BWENB26_flag,
                BWENB25_flag,
                BWENB24_flag,
                BWENB23_flag,
                BWENB22_flag,
                BWENB21_flag,
                BWENB20_flag,
                BWENB19_flag,
                BWENB18_flag,
                BWENB17_flag,
                BWENB16_flag,
                BWENB15_flag,
                BWENB14_flag,
                BWENB13_flag,
                BWENB12_flag,
                BWENB11_flag,
                BWENB10_flag,
                BWENB9_flag,
                BWENB8_flag,
                BWENB7_flag,
                BWENB6_flag,
                BWENB5_flag,
                BWENB4_flag,
                BWENB3_flag,
                BWENB2_flag,
                BWENB1_flag,
                BWENB0_flag};
    AB_flag = {
		AB8_flag,
		AB7_flag,
		AB6_flag,
		AB5_flag,
		AB4_flag,
		AB3_flag,
		AB2_flag,
		AB1_flag,
                AB0_flag};
    DB_flag = {
		DB31_flag,
		DB30_flag,
		DB29_flag,
		DB28_flag,
		DB27_flag,
		DB26_flag,
		DB25_flag,
		DB24_flag,
		DB23_flag,
		DB22_flag,
		DB21_flag,
		DB20_flag,
		DB19_flag,
		DB18_flag,
		DB17_flag,
		DB16_flag,
		DB15_flag,
		DB14_flag,
		DB13_flag,
		DB12_flag,
		DB11_flag,
		DB10_flag,
		DB9_flag,
		DB8_flag,
		DB7_flag,
		DB6_flag,
		DB5_flag,
		DB4_flag,
		DB3_flag,
		DB2_flag,
		DB1_flag,
                DB0_flag};
   end
   endtask

endmodule

`endcelldefine
