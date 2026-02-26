@AccessControl.authorizationCheck: #NOT_REQUIRED 
@EndUserText.label: 'Sales Order Header View - 22AD070' 
@Metadata.ignorePropagatedAnnotations: true 
@Metadata.allowExtensions: true 
define root view entity Z22IT023_I_SLS 
  as select from z22IT023_vbak as Header 
   
  composition [0..*] of Z22IT023_I_SLSITM as _Salesitem  
   
{ 
    key salesdocument       as SalesDocument, 
    salesdocumenttype       as SalesDocumentType, 
    orderreason             as OrderReason, 
    salesorganization       as SalesOrganization, 
    distributionchannel     as DistributionChannel, 
    division                as Division, 
    salesoffice             as SalesOffice, 
    salesgroup              as SalesGroup, 
     
    @Semantics.amount.currencyCode: 'Currency' 
    netprice                as NetPrice,  
    currency                as Currency, 
    @Semantics.user.createdBy: true 
    local_created_by        as LocalCreatedBy, 
@Semantics.systemDateTime.createdAt: true 
local_created_at        
as LocalCreatedAt,  
@Semantics.user.localInstanceLastChangedBy: true 
local_last_changed_by   as LocalLastChangedBy, 
@Semantics.systemDateTime.localInstanceLastChangedAt: true 
local_last_changed_at   as LocalLastChangedAt,  
@Semantics.systemDateTime.lastChangedAt: true 
last_changed_at   as LastChangedAt,    
_Salesitem  
}
