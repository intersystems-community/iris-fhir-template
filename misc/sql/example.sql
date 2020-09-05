/* Select all Observation of Patient/1 */
SELECT 
*
FROM HSFHIR_I0001_S.Observation
where patient = 'Patient/1' ;

/* Select all Observation of Patient/1 with lonic code 718-7 (Hemoglobin [Mass/volume] in Blood)*/
SELECT 
*
FROM HSFHIR_I0001_S.Observation
where patient = 'Patient/1' and code [ '718-7';

/* Get detail of the observation/16 */
SELECT 
*
FROM HSFHIR_I0001_R.Rsrc where Key = 'Observation/16';

/* Get valueQuantity of the observation/16 */
SELECT 
ID, Key, ResourceString, 
GetJSON(ResourceString,'valueQuantity') as valueQuantity
FROM HSFHIR_I0001_R.Rsrc where Key = 'Observation/16';

/* Get value of valueQuantity of the observation/16 */
SELECT 
ID, Key, ResourceString, 
GetJSON(ResourceString,'valueQuantity') as valueQuantity,
GetProp(GetJSON(ResourceString,'valueQuantity'),'value') as value
FROM HSFHIR_I0001_R.Rsrc where Key = 'Observation/16';

/* An complexe example */
SELECT 
ID, Key, ResourceString, 
GetJSON(ResourceString,'code') as code, 
GetJSON(GetJSON(ResourceString,'code'),'coding') as coding,
GetAtJSON(GetJSON(GetJSON(ResourceString,'code'),'coding'),0) as coding1,
GetJSON(GetAtJSON(GetJSON(GetJSON(ResourceString,'code'),'coding'),0),'display') as display,
GetProp(GetJSON(GetAtJSON(GetJSON(GetJSON(ResourceString,'code'),'coding'),0),'display'),'display') as value
FROM HSFHIR_I0001_R.Rsrc where Key = 'Observation/16';
