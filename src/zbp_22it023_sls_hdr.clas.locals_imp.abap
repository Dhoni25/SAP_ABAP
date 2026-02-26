CLASS lhc_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Header RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Header.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Header.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Header.

    METHODS read FOR READ
      IMPORTING keys FOR READ Header RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK Header.

    METHODS rba_salesitem FOR READ
      IMPORTING keys_rba FOR READ Header\_Salesitem FULL result_requested RESULT result LINK association_links.

    METHODS cba_salesitem FOR MODIFY
      IMPORTING entities_cba FOR CREATE Header\_Salesitem.

ENDCLASS.

CLASS lhc_header IMPLEMENTATION.

  METHOD get_instance_authorizations.
    " Implementation for instance-based authorization checks
  ENDMETHOD.

  METHOD get_global_authorizations.
    " Implementation for global authorization checks
  ENDMETHOD.

  METHOD create.
    DATA: ls_sales_hdr TYPE z22it023_vbak.

    LOOP AT entities INTO DATA(ls_entities).
      ls_sales_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_hdr-salesdocument IS NOT INITIAL.
        SELECT SINGLE salesdocument FROM z22it023_vbak
          WHERE salesdocument = @ls_sales_hdr-salesdocument
          INTO @DATA(lv_dummy).

        IF sy-subrc <> 0.
          DATA(lo_util) = zcl_22it023_sales_util=>get_instance( ).
          lo_util->set_hdr_value( EXPORTING im_sales_hdr = ls_sales_hdr
                                  IMPORTING ex_created   = DATA(lv_created) ).

          IF lv_created = abap_true.
            APPEND VALUE #( %cid          = ls_entities-%cid
                            salesdocument = ls_sales_hdr-salesdocument ) TO mapped-header.

            APPEND VALUE #( %cid          = ls_entities-%cid
                            salesdocument = ls_sales_hdr-salesdocument
                            %msg          = new_message( id       = 'Z22AD070_MSG'
                                                         number   = 001
                                                         v1       = 'Sales Order Created'
                                                         severity = if_abap_behv_message=>severity-success )
                          ) TO reported-header.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid          = ls_entities-%cid
                          salesdocument = ls_sales_hdr-salesdocument ) TO failed-header.

          APPEND VALUE #( %cid          = ls_entities-%cid
                          salesdocument = ls_sales_hdr-salesdocument
                          %msg          = new_message( id       = 'Z22AD070_MSG'
                                                         number   = 001
                                                         v1       = 'Duplicate Sales Order'
                                                         severity = if_abap_behv_message=>severity-error )
                        ) TO reported-header.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_sales_hdr TYPE z22it023_vbak.

    LOOP AT entities INTO DATA(ls_entities).
      ls_sales_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_hdr-salesdocument IS NOT INITIAL.
        SELECT SINGLE salesdocument FROM z22it023_vbak
          WHERE salesdocument = @ls_sales_hdr-salesdocument
          INTO @DATA(lv_dummy).

        IF sy-subrc = 0.
          DATA(lo_util) = zcl_22it023_sales_util=>get_instance( ).
          lo_util->set_hdr_value( EXPORTING im_sales_hdr = ls_sales_hdr
                                  IMPORTING ex_created   = DATA(lv_created) ).

          IF lv_created = abap_true.
            APPEND VALUE #( %key = ls_entities-%key
                            %msg = new_message( id       = 'Z22AD070_MSG'
                                                number   = 001
                                                v1       = 'Sales Order Updation Successful'
                                                severity = if_abap_behv_message=>severity-success )
                          ) TO reported-header.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid      = ls_entities-%cid_ref
                          salesdocument = ls_sales_hdr-salesdocument ) TO failed-header.

          APPEND VALUE #( %cid      = ls_entities-%cid_ref
                          salesdocument = ls_sales_hdr-salesdocument
                          %msg          = new_message( id       = 'Z22AD070_MSG'
                                                       number   = 001
                                                       v1       = 'Sales Order Not Found !'
                                                       severity = if_abap_behv_message=>severity-error )
                        ) TO reported-header.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA(lo_util) = zcl_22it023_sales_util=>get_instance( ).

    LOOP AT keys INTO DATA(ls_key).
      lo_util->set_hdr_t_deletion( EXPORTING im_sales_doc = VALUE #( salesdocument = ls_key-salesdocument ) ).
      lo_util->set_hdr_deletion_flag( EXPORTING im_so_delete = abap_true ).

      APPEND VALUE #( %cid      = ls_key-%cid_ref
                      salesdocument = ls_key-salesdocument
                      %msg          = new_message( id       = 'Z22AD070_MSG'
                                                   number   = 001
                                                   v1       = 'Sales Order Deletion Successful'
                                                   severity = if_abap_behv_message=>severity-success )
                    ) TO reported-header.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE * FROM z22it023_vbak
        WHERE salesdocument = @ls_key-salesdocument
        INTO @DATA(ls_hdr).

      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    " Lock logic usually handled by the framework if 'lock master' is defined
  ENDMETHOD.

  METHOD rba_salesitem.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT * FROM z22it023_vbap
        WHERE salesdocument = @ls_key-salesdocument
        INTO TABLE @DATA(lt_items).

      LOOP AT lt_items INTO DATA(ls_item).
        APPEND CORRESPONDING #( ls_item ) TO result.

        APPEND VALUE #( source-salesdocument    = ls_key-salesdocument
                        target-salesdocument    = ls_item-salesdocument
                        target-salesitemnumber  = ls_item-salesitemnumber ) TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_salesitem.
    DATA: ls_sales_itm TYPE z22it023_vbap.

    LOOP AT entities_cba INTO DATA(ls_entities_cba).
      LOOP AT ls_entities_cba-%target INTO DATA(ls_target).
        ls_sales_itm = CORRESPONDING #( ls_target MAPPING FROM ENTITY ).

        IF ls_sales_itm-salesdocument IS NOT INITIAL AND ls_sales_itm-salesitemnumber IS NOT INITIAL.

          SELECT SINGLE salesdocument FROM z22it023_vbap
            WHERE salesdocument   = @ls_sales_itm-salesdocument
              AND salesitemnumber = @ls_sales_itm-salesitemnumber
            INTO @DATA(lv_dummy).

          IF sy-subrc <> 0.
            DATA(lo_util) = zcl_22it023_sales_util=>get_instance( ).
            lo_util->set_itm_value( EXPORTING im_sales_itm = ls_sales_itm
                                    IMPORTING ex_created   = DATA(lv_created) ).

            IF lv_created = abap_true.
              APPEND VALUE #( %cid            = ls_target-%cid
                              salesdocument   = ls_sales_itm-salesdocument
                              salesitemnumber = ls_sales_itm-salesitemnumber ) TO mapped-item.

              APPEND VALUE #( %cid          = ls_target-%cid
                              salesdocument = ls_sales_itm-salesdocument
                              %msg          = new_message( id       = 'Z22AD070_MSG'
                                                           number   = 001
                                                           v1       = 'Sales Item Creation Successful'
                                                           severity = if_abap_behv_message=>severity-success )
                            ) TO reported-item.
            ENDIF.
          ELSE.
            APPEND VALUE #( %cid            = ls_target-%cid
                            salesdocument   = ls_sales_itm-salesdocument
                            salesitemnumber = ls_sales_itm-salesitemnumber ) TO failed-item.

            APPEND VALUE #( %cid            = ls_target-%cid
                            salesdocument   = ls_sales_itm-salesdocument
                            salesitemnumber = ls_sales_itm-salesitemnumber
                            %msg            = new_message( id       = 'Z22AD070_MSG'
                                                           number   = 002
                                                           v1       = 'Duplicate Sales Item'
                                                           severity = if_abap_behv_message=>severity-error )
                          ) TO reported-item.
          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
