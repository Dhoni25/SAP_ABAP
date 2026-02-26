CLASS lhc_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
 PRIVATE SECTION.
 METHODS update FOR MODIFY
 IMPORTING entities FOR UPDATE Item.
 METHODS delete FOR MODIFY
 IMPORTING keys FOR DELETE Item.
 METHODS read FOR READ
 IMPORTING keys FOR READ Item RESULT result.
 METHODS rba_Salesheader FOR READ
 IMPORTING keys_rba FOR READ Item\_Salesheader FULL result_requested RESULT
result LINK association_links.
ENDCLASS.

CLASS lhc_Item IMPLEMENTATION.
 METHOD update.
 DATA : ls_sales_itm TYPE z22it023_vbap.
 LOOP AT entities INTO DATA(ls_entities).
 ls_sales_itm = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
 IF ls_sales_itm-salesdocument IS NOT INITIAL.
 SELECT * FROM z22it023_vbap
 WHERE salesdocument = @ls_sales_itm-salesdocument
 AND salesitemnumber = @ls_sales_itm-salesitemnumber
 INTO TABLE @DATA(lt_sales_itm).
 IF sy-subrc EQ 0.
 DATA(lo_util) = zcl_22it023_sales_util=>get_instance( ).
 lo_util->set_itm_value( EXPORTING im_sales_itm = ls_sales_itm
 IMPORTING ex_created = DATA(lv_created) ).
 IF lv_created EQ abap_true.
 APPEND VALUE #( salesdocument = ls_sales_itm-salesdocument
 salesitemnumber = ls_sales_itm-salesitemnumber ) TO mapped-item.
 APPEND VALUE #( %key = ls_entities-%key
 %msg = new_message( id = 'Z22IT023_MSG'
 number = 001
 v1 = 'Sales Item Updation Successful'
 severity = if_abap_behv_message=>severity-success ) ) TO
 reported-item.
 ENDIF.
 ELSE.
 APPEND VALUE #( %cid = ls_entities-%cid_ref
 salesdocument = ls_sales_itm-salesdocument
 salesitemnumber = ls_sales_itm-salesitemnumber ) TO failed-item.
 APPEND VALUE #( %cid = ls_entities-%cid_ref
 salesdocument = ls_sales_itm-salesdocument
 salesitemnumber = ls_sales_itm-salesitemnumber
 %msg = new_message( id = 'Z22IT023_MSG'
 number = 001
 v1 = 'Sales Item Not Found'
 severity = if_abap_behv_message=>severity-error ) ) TO
 reported-item.
 ENDIF.
 ENDIF.
 ENDLOOP.
 ENDMETHOD.

 METHOD delete.
 TYPES : BEGIN OF ty_sales_hdr,
 salesdocument TYPE z22it023_de_sorder,
 END OF ty_sales_hdr,
 BEGIN OF ty_sales_item,
 salesdocument TYPE z22it023_de_sorder,
 salesitemnumber TYPE int2,
 END OF ty_sales_item.

 DATA ls_sales_itm TYPE ty_sales_item.
 DATA(lo_util) = zcl_22it023_sales_util=>get_instance( ).

 LOOP AT keys INTO DATA(ls_key).
 CLEAR ls_sales_itm.
 ls_sales_itm-salesdocument = ls_key-salesdocument.
 ls_sales_itm-salesitemnumber = ls_key-SalesItemnumber.

 lo_util->set_itm_t_deletion( im_sales_itm_info = ls_sales_itm ).

 APPEND VALUE #( %cid = ls_key-%cid_ref
 salesdocument = ls_key-salesdocument
 salesitemnumber = ls_key-SalesItemnumber
 %msg = new_message( id = 'Z22IT023_MSG'
 number = 001
 v1 = 'Sales Item Deletion Successful'
 severity = if_abap_behv_message=>severity-success ) ) TO
 reported-item.
 ENDLOOP.
 ENDMETHOD.

 METHOD read.
 ENDMETHOD.

 METHOD rba_Salesheader.
 ENDMETHOD.
ENDCLASS.
