include("gridBlocks.jl")

module DistanceFields

    using ..GridBlocks: HexaMesh


mutable struct SDField
    mesh::HexaMesh
    field::Array{Float64, 3}

    function SDField(mesh_tmp, phi::Function)

        datatmp = Array{Float64, 3}(undef, mesh_tmp.nx, mesh_tmp.ny, mesh_tmp.nz)

        for k=1:mesh_tmp.nz, j=1:mesh_tmp.ny, i=1:mesh_tmp.nx
            datatmp[i,j,k] = phi(mesh_tmp.spaceX[i,j,k], mesh_tmp.spaceY[i,j,k], mesh_tmp.spaceZ[i,j,k])
        end

        new(mesh_tmp, datatmp);
    end # contructor SDField
end# struct SDField

function  add(self::SDField, sdf::SDField)

    nx = self.mesh.nx
    ny = self.mesh.ny
    nz = self.mesh.nz

    for k=1:nz, j=1:ny, i=1:nx
        self.field[i,j,k] = max( self.field[i,j,k],  sdf.field[i,j,k])
    end
end

function  subs(self::SDField, sdf::SDField)

    nx = self.mesh.nx
    ny = self.mesh.ny
    nz = self.mesh.nz

    for k=1:nz, j=1:ny, i=1:nx
        self.field[i,j,k] = min( self.field[i,j,k],  sdf.field[i,j,k])
    end
end

planeX(a) = (x,y,z) -> -(x - a)
planeY(a) = (x,y,z) -> -(y - a)
planeZ(a) = (x,y,z) -> -(z - a)

sphere(x0, y0, z0, r) = (x,y,z) -> sqrt((x - x0)^2 + (y - y0)^2 + (z - z0)^2) - r

cilinder_X(y0, z0, r)  = (x,y,z) -> sqrt((y - y0)^2 + (z - z0)^2) - r
cilinder_Y(x0, z0, r)  = (x,y,z) -> sqrt((x - x0)^2 + (z - z0)^2) - r
cilinder_Z(x0, y0, r)  = (x,y,z) -> sqrt((x - x0)^2 + (y - y0)^2) - r

function Base.:>>(self::SDField, sdf::SDField)
    nx = self.mesh.nx
    ny = self.mesh.ny
    nz = self.mesh.nz

    for k=1:nz, j=1:ny, i=1:nx
        self.field[i,j,k] = min( self.field[i,j,k],  sdf.field[i,j,k])
    end
end

function Base.:<<(self::SDField, sdf::SDField)
    nx = self.mesh.nx
    ny = self.mesh.ny
    nz = self.mesh.nz

    for k=1:nz, j=1:ny, i=1:nx
        self.field[i,j,k] = max( self.field[i,j,k],  sdf.field[i,j,k])
    end
end

end # module SDField