@AccessControl.authorizationCheck: #NOT_REQUIRED 
@EndUserText.label: 'Sales Order Header Consumption View' 
@Metadata.ignorePropagatedAnnotations: true 
@Metadata.allowExtensions: true 
@Search.searchable: true 
 
define root view entity Z22IT023_C_SALESHD 
  provider contract transactional_query 
  as projection on Z22IT023_I_SLS 
{ 
    key SalesDocument, 
    SalesDocumentType, 
    OrderReason, 
    SalesOrganization, 
    DistributionChannel, 
    Division, 
    @Search.defaultSearchElement: true 
    SalesOffice,  
    SalesGroup, 
    @Semantics.amount.currencyCode: 'Currency' 
    NetPrice, 
    Currency, 
    LocalCreatedBy, 
    LocalCreatedAt, 
    LocalLastChangedBy, 
    LocalLastChangedAt, 

_Salesitem : redirected to composition child Z22IT023_C_SALESITM 
}
