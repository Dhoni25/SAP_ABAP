@AbapCatalog.viewEnhancementCategory: [#NONE] 
@AccessControl.authorizationCheck: #NOT_REQUIRED 
@EndUserText.label: 'Sales Order Item View - 22AD070' 
@Metadata.ignorePropagatedAnnotations: true 
@Metadata.allowExtensions: true 
@ObjectModel.usageType:{ 
serviceQuality: #X, 
sizeCategory: #S, 
dataClass: #MIXED 
} 
define view entity Z22IT023_I_SLSITM 
  as select from z22IT023_vbap as Item 
 
  association to parent Z22IT023_I_SLS as _SalesHeader  
    on $projection.SalesDocument = _SalesHeader.SalesDocument 
     
{ 
    key salesdocument       as SalesDocument, 
    key salesitemnumber     as SalesItemNumber, 
    material                as Material, 
    plant                   as Plant, 
     
    @Semantics.quantity.unitOfMeasure: 'QuantityUnit' 
    quantity                as Quantity, 
    quantityunits           as QuantityUnit, 
    @Semantics.user.createdBy: true 
    local_created_by        as LocalCreatedBy, 
    @Semantics.systemDateTime.createdAt: true 
    local_created_at        as LocalCreatedAt, 
    @Semantics.user.localInstanceLastChangedBy: true 
    local_last_changed_by   as LocalLastChangedBy, 
    @Semantics.systemDateTime.localInstanceLastChangedAt: true 
    local_last_changed_at   as LocalLastChangedAt, 
    _SalesHeader 
}
