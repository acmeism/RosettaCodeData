<!--- Create sample JSON structure --->
<cfset json = {
  string: "Hello",
  number: 42,
  arrayOfNumbers: [1, 2, 3, 4],
  arrayOfStrings: ["One", "Two", "Three", "Four"],
  arrayOfAnything: [1, "One", [1, "One"], { one: 1 }],
  object: {
    key: "value"
  }
} />

<!--- Convert to JSON string --->
<cfset jsonSerialized = serializeJSON(json) />
<!--- Convert back to ColdFusion --->
<cfset jsonDeserialized = deserializeJSON(jsonSerialized) />

<!--- Output examples --->
<cfdump var="#jsonSerialized#" />
<cfdump var="#jsonDeserialized#" />
