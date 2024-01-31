/* Select all Patients */
SELECT
* 
FROM HSFHIR_X0001_S.Patient;
/* Select all Observation of Patient/4 */
SELECT
* FROM HSFHIR_X0001_S.Observation
where patient = 'Patient/4';
/* Select all Observation of Patient/4 with lonic code 718-7 (Hemoglobin [Mass/volume] in Blood)*/
SELECT 
*
FROM HSFHIR_X0001_S.Observation
where patient = 'Patient/4' and code [ '718-7';

/* Get detail of the Observation/101 */
SELECT 
*
FROM HSFHIR_X0001_R.Rsrc where Key = 'Observation/101';

/* Get valueQuantity of the Observation/101 */
SELECT 
ID
, Key
, ResourceString
, GetJSON(ResourceString,'valueQuantity') as valueQuantity
FROM HSFHIR_X0001_R.Rsrc where Key = 'Observation/101';

/* Get value of valueQuantity of the Observation/101 */
SELECT 
ID
, Key
, ResourceString
, GetJSON(ResourceString,'valueQuantity') as valueQuantity
, GetProp(GetJSON(ResourceString,'valueQuantity'),'value') as value
FROM HSFHIR_X0001_R.Rsrc where Key = 'Observation/101';

/* An complexe example */
SELECT 
ID, Key, ResourceString
, GetJSON(ResourceString,'code') as code
, GetJSON(GetJSON(ResourceString,'code'),'coding') as coding
, GetAtJSON(GetJSON(GetJSON(ResourceString,'code'),'coding'),0) as coding1
, GetJSON(GetAtJSON(GetJSON(GetJSON(ResourceString,'code'),'coding'),0),'display') as display
, GetProp(GetJSON(GetAtJSON(GetJSON(GetJSON(ResourceString,'code'),'coding'),0),'display'),'display') as value
FROM HSFHIR_X0001_R.Rsrc where Key = 'Observation/101';