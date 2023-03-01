
include("gridBlocks.jl")

module vtkIO

using ..GridBlocks:HexaMesh
using Printf

function vtkWriter(self, fields... )

   io = open("mesh.vtk", "w")
   
   write(io, "# vtk DataFile Version 2.3\n")
   write(io, "3D Mesh\n")
   write(io, "ASCII\n\n")
   write(io, "DATASET STRUCTURED_GRID\n")
   write(io, "DIMENSIONS $(self.nx) $(self.ny) $(self.nz)\n")
   write(io, "POINTS $(self.nx*self.ny*self.nz) float\n")

   for k=1:self.nz, j=1:self.ny, i=1:self.nx
        @printf(io, "%16.10f %16.10f %16.10f\n", self.spaceX[i,j,k], self.spaceY[i,j,k], self.spaceZ[i,j,k]) 
   end


    for fieldId = 1:convert(Int64, length(fields))
       println("Writing field number: $fieldId\n")
       if fieldId == 1
            @printf(io, "\nPOINT_DATA %i\n", self.nx*self.ny*self.nz)
       end

       fieldTmp = fields[fieldId]
       println("Field $fieldId has a type of $(typeof(fieldTmp)) \n")
       vtkWriteField(io, fieldTmp, fieldId)
    end

   close(io)

end

function vtkWriteField(io::IOStream, genericdata, fieldId::Int64)
    println("No written for $(string(fieldId))\n")
end

function vtkWriteField(io::IOStream, fieldTmp::Array{Float64,3}, fieldId::Int64)
    println("Writing an Array for $(string(fieldId))\n")

    @printf(io, "SCALARS F%s float\n", string(fieldId))
    @printf(io, "LOOKUP_TABLE default\n")
 
    nx = size(fieldTmp, 1)
    ny = size(fieldTmp, 2)
    nz = size(fieldTmp, 3)

    for k=1:nz, j=1:ny, i=1:nx
     @printf(io, "%16.6f\n", fieldTmp[i,j,k])
    end
end

function vtkWriteField(io::IOStream, tupleField::Tuple{Array{Float64,3},String}, fieldId::Int64)
    println("Writing an Array for $(tupleField[2])\n")

    fieldTmp = tupleField[1]
    @printf(io, "SCALARS %s float\n", tupleField[2])
    @printf(io, "LOOKUP_TABLE default\n")
 
    nx = size(fieldTmp, 1)
    ny = size(fieldTmp, 2)
    nz = size(fieldTmp, 3)

    for k=1:nz, j=1:ny, i=1:nx
     @printf(io, "%16.6f\n", fieldTmp[i,j,k])
    end
end

end