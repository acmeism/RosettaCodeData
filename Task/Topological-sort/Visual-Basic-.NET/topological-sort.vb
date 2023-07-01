' Adapted from:
' http://tawani.blogspot.com/2009/02/topological-sorting-and-cyclic.html
' added/changed:
' - conversion to VB.Net (.Net 2 framework)
' - added Rosetta Code dependency format parsing
' - check & removal of self-dependencies before sorting
Module Program
	Sub Main()
		Dim Fields As New List(Of Field)()
		' You can also add Dependson using code like:
		' .DependsOn = New String() {"ieee", "dw01", "dware"} _

		fields.Add(New Field() With { _
			.Name = "des_system_lib", _
			.DependsOn = Split("std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee", " ") _
		})
		fields.Add(New Field() With { _
			.Name = "dw01", _
			.DependsOn = Split("ieee dw01 dware gtech", " ") _
		})
		fields.Add(New Field() With { _
			.Name = "dw02", _
			.DependsOn = Split("ieee dw02 dware", " ") _
		})
		fields.Add(New Field() With { _
			.Name = "dw03", _
			.DependsOn = Split("std synopsys dware dw03 dw02 dw01 ieee gtech", " ") _			
		})
		fields.Add(New Field() With { _
			.Name = "dw04", _
			.DependsOn = Split("dw04 ieee dw01 dware gtech", " ") _			
		})
		fields.Add(New Field() With { _
			.Name = "dw05", _
			.DependsOn = Split("dw05 ieee dware", " ") _
		})
		fields.Add(New Field() With { _
			.Name = "dw06", _
			.DependsOn = Split("dw06 ieee dware", " ") _			
		})
		fields.Add(New Field() With { _
			.Name = "dw07", _
			.DependsOn = Split("ieee dware", " ") _			
		})
		fields.Add(New Field() With { _
			.Name = "dware", _
			.DependsOn = Split("ieee dware", " ") _
		})
		fields.Add(New Field() With { _
			.Name = "gtech", _
			.DependsOn = Split("ieee gtech", " ") _			
		})
		fields.Add(New Field() With { _
			.Name = "ramlib", _
			.DependsOn = Split("std ieee", " ") _			
		})
		fields.Add(New Field() With { _
			.Name = "std_cell_lib", _
			.DependsOn = Split("ieee std_cell_lib", " ") _			
		})
		fields.Add(New Field() With { _
			.Name = "synopsys" _
		})		
		Console.WriteLine("Input:")
		For Each ThisField As field In fields
			Console.WriteLine(ThisField.Name)
			If ThisField.DependsOn IsNot Nothing Then
				For Each item As String In ThisField.DependsOn
					Console.WriteLine(" -{0}", item)
				Next
			End If
		Next

		Console.WriteLine(vbLf & "...Sorting..." & vbLf)

		Dim sortOrder As Integer() = getTopologicalSortOrder(fields)

		For i As Integer = 0 To sortOrder.Length - 1
			Dim field = fields(sortOrder(i))
			Console.WriteLine(field.Name)
			' Write up dependencies, too:
			'If field.DependsOn IsNot Nothing Then
			'	For Each item As String In field.DependsOn
			'		Console.WriteLine(" -{0}", item)
			'	Next
			'End If
		Next
		Console.Write("Press any key to continue . . . ")
		Console.ReadKey(True)
	End Sub
	
	Private Sub CheckDependencies (ByRef Fields As List(Of Field))
		' Make sure all objects we depend on are part of the field list
		' themselves, as there may be dependencies that are not specified as fields themselves.
		' Remove dependencies on fields themselves.Y			
		Dim AField As Field, ADependency As String
		
		For i As Integer = Fields.Count - 1 To 0 Step -1
			AField=fields(i)
			If AField.DependsOn IsNot Nothing  then
				For j As Integer = 0 To Ubound(AField.DependsOn)
					ADependency = Afield.DependsOn(j)
					' We ignore fields that depends on themselves:
					If AField.Name <> ADependency then
						If ListContainsVertex(fields, ADependency) = False Then
							' Add the dependent object to the field list, as it
							' needs to be there, without any dependencies
							Fields.Add(New Field() With { _
								.Name = ADependency _
							})
						End If
					End If
				Next j
			End If
		Next i	
	End Sub
	
	Private Sub RemoveSelfDependencies (ByRef Fields As List(Of Field))
		' Make sure our fields don't depend on themselves.
		' If they do, remove the dependency.
		Dim InitialUbound as Integer
		For Each AField As Field In Fields			
			If AField.DependsOn IsNot Nothing Then
				InitialUbound = Ubound(AField.DependsOn)
				For i As Integer = InitialUbound to 0 Step - 1
					If Afield.DependsOn(i) = Afield.Name Then
						' This field depends on itself, so remove
						For j as Integer = i To UBound(AField.DependsOn)-1
							Afield.DependsOn(j)=Afield.DependsOn(j+1)
						Next
						ReDim Preserve Afield.DependsOn(UBound(Afield.DependsOn)-1)
					End If
				Next
			End If			
		Next
	End Sub	
			
	Private Function ListContainsVertex(Fields As List(Of Field), VertexName As String) As Boolean
	' Check to see if the list of Fields already contains a vertext called VertexName
	Dim Found As Boolean = False
		For i As Integer = 0 To fields.Count - 1
			If Fields(i).Name = VertexName Then
				Found = True
				Exit For
			End If
		Next
		Return Found
	End Function

	Private Function getTopologicalSortOrder(ByRef Fields As List(Of Field)) As Integer()
		' Gets sort order. Will also add required dependencies to
		' Fields.
		
		' Make sure we don't have dependencies on ourselves.
		' We'll just get rid of them.
		RemoveSelfDependencies(Fields)
		
		'First check depencies, add them to Fields if required:
		CheckDependencies(Fields)
		' Now we have the correct Fields list, so we can proceed:
		Dim g As New TopologicalSorter(fields.Count)
		Dim _indexes As New Dictionary(Of String, Integer)(fields.count)

		'add vertex names to our lookup dictionaey
		For i As Integer = 0 To fields.Count - 1
			_indexes(fields(i).Name.ToLower()) = g.AddVertex(i)
		Next

		'add edges
		For i As Integer = 0 To fields.Count - 1
			If fields(i).DependsOn IsNot Nothing Then
				For j As Integer = 0 To fields(i).DependsOn.Length - 1
					g.AddEdge(i, _indexes(fields(i).DependsOn(j).ToLower()))
				Next
			End If
		Next

		Dim result As Integer() = g.Sort()
		Return result
	End Function

	Private Class Field
		Public Property Name() As String
			Get
				Return m_Name
			End Get
			Set
				m_Name = Value
			End Set
		End Property
		Private m_Name As String
		Public Property DependsOn() As String()
			Get
				Return m_DependsOn
			End Get
			Set
				m_DependsOn = Value
			End Set
		End Property
		Private m_DependsOn As String()
	End Class
End Module
Class TopologicalSorter
	''source adapted from:
	''http://tawani.blogspot.com/2009/02/topological-sorting-and-cyclic.html
	''which was adapted from:
	''http://www.java2s.com/Code/Java/Collections-Data-Structure/Topologicalsorting.htm
	#Region "- Private Members -"

	Private ReadOnly _vertices As Integer()
	' list of vertices
	Private ReadOnly _matrix As Integer(,)
	' adjacency matrix
	Private _numVerts As Integer
	' current number of vertices
	Private ReadOnly _sortedArray As Integer()
	' Sorted vertex labels

	#End Region

	#Region "- CTors -"

	Public Sub New(size As Integer)
		_vertices = New Integer(size - 1) {}
		_matrix = New Integer(size - 1, size - 1) {}
		_numVerts = 0
		For i As Integer = 0 To size - 1
			For j As Integer = 0 To size - 1
				_matrix(i, j) = 0
			Next
		Next
			' sorted vert labels
		_sortedArray = New Integer(size - 1) {}
	End Sub

	#End Region

	#Region "- Public Methods -"

	Public Function AddVertex(vertex As Integer) As Integer
		_vertices(System.Threading.Interlocked.Increment(_numVerts)-1) = vertex
		Return _numVerts - 1
	End Function

	Public Sub AddEdge(start As Integer, [end] As Integer)
		_matrix(start, [end]) = 1
	End Sub

	Public Function Sort() As Integer()
	' Topological sort
		While _numVerts > 0
			' while vertices remain,
			' get a vertex with no successors, or -1
			Dim currentVertex As Integer = noSuccessors()
			If currentVertex = -1 Then
				' must be a cycle
				Throw New Exception("Graph has cycles")
			End If

			' insert vertex label in sorted array (start at end)
			_sortedArray(_numVerts - 1) = _vertices(currentVertex)

				' delete vertex
			deleteVertex(currentVertex)
		End While

		' vertices all gone; return sortedArray
		Return _sortedArray
	End Function

	#End Region

	#Region "- Private Helper Methods -"

	' returns vert with no successors (or -1 if no such verts)
	Private Function noSuccessors() As Integer
		For row As Integer = 0 To _numVerts - 1
			Dim isEdge As Boolean = False
			' edge from row to column in adjMat
			For col As Integer = 0 To _numVerts - 1
				If _matrix(row, col) > 0 Then
					' if edge to another,
					isEdge = True
						' this vertex has a successor try another
					Exit For
				End If
			Next
			If Not isEdge Then
				' if no edges, has no successors
				Return row
			End If
		Next
		Return -1
		' no
	End Function

	Private Sub deleteVertex(delVert As Integer)
		' if not last vertex, delete from vertexList
		If delVert <> _numVerts - 1 Then
			For j As Integer = delVert To _numVerts - 2
				_vertices(j) = _vertices(j + 1)
			Next

			For row As Integer = delVert To _numVerts - 2
				moveRowUp(row, _numVerts)
			Next

			For col As Integer = delVert To _numVerts - 2
				moveColLeft(col, _numVerts - 1)
			Next
		End If
		_numVerts -= 1
		' one less vertex
	End Sub

	Private Sub moveRowUp(row As Integer, length As Integer)
		For col As Integer = 0 To length - 1
			_matrix(row, col) = _matrix(row + 1, col)
		Next
	End Sub

	Private Sub moveColLeft(col As Integer, length As Integer)
		For row As Integer = 0 To length - 1
			_matrix(row, col) = _matrix(row, col + 1)
		Next
	End Sub

	#End Region
End Class
