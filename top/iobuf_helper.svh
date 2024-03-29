`ifndef IOBUF_HELPER_SVH
`define IOBUF_HELPER_SVH

`define IOBUF_GEN(IN, OUT)(*mark_debug="true"*)  wire OUT``_i, OUT``_o, OUT``_t; \
IOBUF IN``_buf ( \
    .IO(IN), \
    .I(OUT``_o), \
    .O(OUT``_i), \
    .T(OUT``_t) \
);

`define IOBUF_GEN_SIMPLE(IN) `IOBUF_GEN(IN, IN)

`define IOBUF_GEN_VEC(IN, OUT) wire [$bits(IN) - 1:0] OUT``_i, OUT``_o, OUT``_t; \
genvar IN``_gen_var; \
generate \
  for(IN``_gen_var = 0; IN``_gen_var < $bits(IN); IN``_gen_var = IN``_gen_var + 1) begin: IN``_buf_gen \
    IOBUF IN``_buf ( \
      .IO(IN[IN``_gen_var]), \
      .O(OUT``_i[IN``_gen_var]), \
      .I(OUT``_o[IN``_gen_var]), \
      .T(OUT``_t[IN``_gen_var]) \
    ); \
  end \
endgenerate

`define IOBUF_GEN_VEC_SIMPLE(IN) `IOBUF_GEN_VEC(IN, IN)

`define IOBUF_GEN_VEC_UNIFORM(IN, OUT) wire [$bits(IN) - 1:0] OUT``_i, OUT``_o; \
wire OUT``_t; \
genvar IN``_gen_var; \
generate \
  for(IN``_gen_var = 0; IN``_gen_var < $bits(IN); IN``_gen_var = IN``_gen_var + 1) begin: IN``_buf_gen \
    IOBUF IN``_buf ( \
      .IO(IN[IN``_gen_var]), \
      .O(OUT``_i[IN``_gen_var]), \
      .I(OUT``_o[IN``_gen_var]), \
      .T(OUT``_t) \
    ); \
  end \
endgenerate

`define IOBUF_GEN_VEC_UNIFORM_SIMPLE(IN) `IOBUF_GEN_VEC_UNIFORM(IN, IN)

`define OPAD_GEN(IN, OUT) wire OUT``_c; \
    PO16 IN``_buf ( \
      .PAD(IN), \
      .I(OUT``_c) \
    );

`define OPAD_GEN_SIMPLE(IN) `OPAD_GEN(IN, IN)

`define OEPAD_GEN(IN, OUT) wire OUT``_c, OUT``_t; \
    POT16 IN``_buf ( \
      .PAD(IN), \
      .I(OUT``_c), \
      .OEN(OUT``_t) \
    );

`define OEPAD_GEN_SIMPLE(IN) `OEPAD_GEN(IN, IN)

`define OPAD_GEN_VEC(IN, OUT) wire [$bits(IN)-1:0] OUT``_c; \
genvar IN``_gen_var; \
generate \
  for(IN``_gen_var = 0; IN``_gen_var < $bits(IN); IN``_gen_var = IN``_gen_var + 1) begin: IN``_buf_gen \
    PO16 IN``_buf ( \
      .PAD(IN[IN``_gen_var]), \
      .I(OUT``_c[IN``_gen_var]) \
    ); \
  end \
endgenerate

`define OPAD_GEN_VEC_SIMPLE(IN) `OPAD_GEN_VEC(IN, IN)

`define OPAD_GEN_T(IN, OUT) wire OUT``_c, OUT``_t; \
    POT16 IN``_buf ( \
      .PAD(IN), \
      .I(OUT``_c), \
      .OEN(OUT``_t) \
    );

`define OPAD_GEN_T_SIMPLE(IN) `OPAD_GEN_T(IN, IN)

`define OPAD_GEN_VEC_T_UNIFORM(IN, OUT) wire [$bits(IN)-1:0] OUT``_c; \
wire OUT``_t; \
genvar IN``_gen_var; \
generate \
  for(IN``_gen_var = 0; IN``_gen_var < $bits(IN); IN``_gen_var = IN``_gen_var + 1) begin: IN``_buf_gen \
    POT16 IN``_buf ( \
      .PAD(IN[IN``_gen_var]), \
      .I(OUT``_c[IN``_gen_var]), \
      .OEN(OUT``_t) \
    ); \
  end \
endgenerate

`define OPAD_GEN_VEC_T_UNIFORM_SIMPLE(IN) `OPAD_GEN_VEC_T_UNIFORM(IN, IN)

`define IPAD_GEN(IN, OUT) wire OUT``_c; \
    PI IN``_buf ( \
      .PAD(IN), \
      .C(OUT``_c) \
    );

`define IPAD_GEN_SIMPLE(IN) `IPAD_GEN(IN, IN)

`define IPAD_GEN_VEC(IN, OUT) wire [$bits(IN)-1:0] OUT``_c; \
genvar IN``_gen_var; \
generate \
  for(IN``_gen_var = 0; IN``_gen_var < $bits(IN); IN``_gen_var = IN``_gen_var + 1) begin: IN``_buf_gen \
    PI IN``_buf ( \
      .PAD(IN[IN``_gen_var]), \
      .C(OUT``_c[IN``_gen_var]) \
    ); \
  end \
endgenerate

`define IPAD_GEN_VEC_SIMPLE(IN) `IPAD_GEN_VEC(IN, IN)

`endif
 
