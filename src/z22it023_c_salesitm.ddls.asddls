@AccessControl.authorizationCheck: #NOT_REQUIRED 
@EndUserText.label: 'Sales Order Items Projection View' 
@Metadata.ignorePropagatedAnnotations: true 
@Metadata.allowExtensions: true 
@Search.searchable: true 
define view entity Z22IT023_C_SALESITM 
as projection on Z22IT023_I_SLSITM 
{ 
key SalesDocument, 
key Salesitemnumber, 
@Search.defaultSearchElement: true 
Material,     
Plant, 
@Semantics.quantity.unitOfMeasure: 'QuantityUnit' 
Quantity, 
QuantityUnit, 
LocalCreatedBy, 
LocalCreatedAt, 
LocalLastChangedBy, 
LocalLastChangedAt, 
_Salesheader : redirected to parent Z22IT023_C_SALESHD
}
