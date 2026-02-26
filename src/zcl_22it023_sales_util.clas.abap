CLASS ZCL_22IT023_SALES_UTIL DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES : BEGIN OF ty_sales_hdr,
              salesdocument TYPE z22IT023_de_sorder,
            END OF ty_sales_hdr,
            BEGIN OF ty_sales_item,
              salesdocument   TYPE z22IT023_de_sorder,
              salesitemnumber TYPE int2,
            END OF ty_sales_item.

    TYPES : tt_sales_item TYPE STANDARD TABLE OF ty_sales_item WITH EMPTY KEY,
            tt_sales_hdr  TYPE STANDARD TABLE OF ty_sales_hdr WITH EMPTY KEY.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO ZCL_22IT023_SALES_UTIL.

    METHODS :
      set_hdr_value         IMPORTING im_sales_hdr TYPE z22IT023_vbak
                            EXPORTING ex_created   TYPE abap_boolean,
      get_hdr_value         EXPORTING ex_sales_hdr TYPE z22IT023_vbak,

      set_itm_value         IMPORTING im_sales_itm TYPE z22IT023_vbap
                            EXPORTING ex_created   TYPE abap_boolean,
      get_itm_value         EXPORTING ex_sales_itm TYPE z22IT023_vbap,

      set_hdr_t_deletion    IMPORTING im_sales_doc      TYPE ty_sales_hdr,
      set_itm_t_deletion    IMPORTING im_sales_itm_info TYPE ty_sales_item,
      get_hdr_t_deletion    EXPORTING ex_sales_docs     TYPE tt_sales_hdr,
      get_itm_t_deletion    EXPORTING ex_sales_info     TYPE tt_sales_item,

      set_hdr_deletion_flag IMPORTING im_so_delete  TYPE abap_boolean,
      get_deletion_flags    EXPORTING ex_so_hdr_del TYPE abap_boolean,

      cleanup_buffer.

  PROTECTED SECTION.

  PRIVATE SECTION.
    CLASS-DATA : gs_sales_hdr_buff   TYPE z22IT023_vbak,
                 gs_sales_itm_buff   TYPE z22IT023_vbap,
                 gt_sales_hdr_t_buff TYPE tt_sales_hdr,
                 gt_sales_itm_t_buff TYPE tt_sales_item,
                 gv_so_delete        TYPE abap_boolean,
                 mo_instance         TYPE REF TO ZCL_22IT023_SALES_UTIL.
ENDCLASS.



CLASS ZCL_22IT023_SALES_UTIL IMPLEMENTATION.


  METHOD get_itm_t_deletion.
    ex_sales_info = gt_sales_itm_t_buff.
  ENDMETHOD.


  METHOD set_itm_t_deletion.
    APPEND im_sales_itm_info TO gt_sales_itm_t_buff.
  ENDMETHOD.


  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.


  METHOD set_hdr_deletion_flag.
    gv_so_delete = im_so_delete.
  ENDMETHOD.


  METHOD set_hdr_value.
    IF im_sales_hdr-salesdocument IS NOT INITIAL.
      gs_sales_hdr_buff = im_sales_hdr.
      ex_created = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD set_itm_value.
    IF im_sales_itm IS NOT INITIAL.
      gs_sales_itm_buff = im_sales_itm.
      ex_created = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD get_hdr_value.
    ex_sales_hdr = gs_sales_hdr_buff.
  ENDMETHOD.


  METHOD get_itm_value.
    ex_sales_itm = gs_sales_itm_buff.
  ENDMETHOD.


  METHOD set_hdr_t_deletion.
    APPEND im_sales_doc TO gt_sales_hdr_t_buff.
  ENDMETHOD.


  METHOD get_hdr_t_deletion.
    ex_sales_docs = gt_sales_hdr_t_buff.
  ENDMETHOD.


  METHOD get_deletion_flags.
    ex_so_hdr_del = gv_so_delete.
  ENDMETHOD.


  METHOD cleanup_buffer.
    CLEAR : gs_sales_hdr_buff,
            gs_sales_itm_buff,
            gt_sales_hdr_t_buff,
            gt_sales_itm_t_buff,
            gv_so_delete.
  ENDMETHOD.
ENDCLASS.
