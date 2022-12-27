Class fhirtemplate.SQLvar
{

ClassMethod GetJSON(json As %String, name As %String) As %String(MAXLEN="") [ SqlName = GetJSON, SqlProc ]
{

    quit:(json="") ""

    set dyna = {}.%FromJSON(json)

    set result = dyna.%Get(name)

    quit $s(result'="":$s(($classname(result)="%Library.DynamicObject")||($classname(result)="%Library.DynamicArray"):result.%ToJSON(),1:{}.%Set(name,result,dyna.%GetTypeOf(name)).%ToJSON()),1:"")
}

ClassMethod GetProp(json As %String, prop As %String) As %String(MAXLEN="") [ SqlName = GetProp, SqlProc ]
{
    quit:(json="") ""

    set dyna = {}.%FromJSON(json)

    Quit dyna.%Get(prop)
}

ClassMethod GetAtJSON(json As %String, position As %Integer) As %String(MAXLEN="") [ SqlName = GetAtJSON, SqlProc ]
{
    quit:(json="") ""

    set dyna = [].%FromJSON(json)
    
    set i = 0
    set iterator = dyna.%GetIterator()
    
    while iterator.%GetNext(.key, .result) {
        quit:(i=position) 
        do $Increment(i)
    }

    Quit $s(result'="":$s(($classname(result)="%Library.DynamicObject")||($classname(result)="%Library.DynamicArray"):result.%ToJSON(),1:{}.%Set(key,result,dyna.%GetTypeOf(key)).%ToJSON()),1:"")
}

/// Return JSON array resulting from FHIRPath query
ClassMethod GetFHIRPath(json As %String, path As %String, mdSetKey As %String = "HL7v40") As %String(MAXLEN="") [ SqlName = GetFHIRPath, SqlProc ]
{
	if (json = "") quit ""
	
	#dim fpAPI As HS.FHIRPath.API = ##class(HS.FHIRPath.API).getInstance(mdSetKey)
	#dim node As HS.FHIRPath.Node = fpAPI.parse(path)

	#dim array As %DynamicArray = fpAPI.evaluateToJson({}.%FromJSON(json), node)
	//#dim array As %DynamicArray = $$%EvaluatePath^%DocDB.Document(json, path)
	if (array = "") quit ""

	quit array.%ToJSON()
}

/// Return just one result, either JSON object/array or a single value. 
/// resourceType argument is used to distinguish arrays from non-arrays.
ClassMethod GetFHIRPathOne(json As %String, path As %String, resourceType As %String, mdSetKey As %String = "HL7v40") As %String(MAXLEN="") [ SqlName = GetFHIRPathOne, SqlProc ]
{
	if (json = "") quit ""
	
	#dim fpAPI As HS.FHIRPath.API = ##class(HS.FHIRPath.API).getInstance(mdSetKey)
	#dim node As HS.FHIRPath.Node = fpAPI.parse(path)

	#dim array As %DynamicArray = fpAPI.evaluateToJson({}.%FromJSON(json), node)
	//#dim array As %DynamicArray = $$%EvaluatePath^%DocDB.Document(json, path)
	if (array = "") quit ""

	do fpAPI.getPathAndType(resourceType, node, .contextPath, .fhirType)
	
	#dim result = array
	if (($get(fhirType("ar")) = $$$NO) || ($extract($zstrip(path, ">W"), *) = "]"))
	{
		set result = array.%Get(0)
	}
	
	quit $case($isObject(result), $$$YES:/*result.%ClassName(1) _ ":" _ */result.%ToJSON(), :result)
}

}

