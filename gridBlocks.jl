
module GridBlocks

mutable struct HexaMesh

    nx::Int64
    ny::Int64
    nz::Int64

    ox::Float64
    oy::Float64
    oz::Float64

    lx::Float64
    ly::Float64
    lz::Float64

    spaceX::Array{Float64,3}
    spaceY::Array{Float64,3}
    spaceZ::Array{Float64,3}

    deltax::Float64
    deltay::Float64
    deltaz::Float64

    function HexaMesh()
     println("INFO::Void Mesh...")

     new(2,2,2,0.0,0.0,0.0,1.0,1.0,1.0,zeros(Float64, 3,3,3),zeros(Float64, 3,3,3), zeros(Float64, 3,3,3),  0.0, 0.0, 0.0);
    end #struct HexaMesh

function HexaMesh(nodes::Vector{Int64}, origin::Vector{Float64}, domsize::Vector{Float64})

    
        new(  nodes[1],      nodes[2],   nodes[3],
              origin[1],     origin[2],  origin[3],
              domsize[1],    domsize[2], domsize[3], 
              zeros(Float64, nodes[1],nodes[2],nodes[3]),
              zeros(Float64, nodes[1],nodes[2],nodes[3]),
              zeros(Float64, nodes[1],nodes[2],nodes[3]),
              0.0, 0.0, 0.0);
    end
end

function meshBuilder(self::GridBlocks.HexaMesh)

    self.deltax = self.lx / convert(Float64, (self.nx - 1))
    self.deltay = self.ly / convert(Float64, (self.ny - 1))
    self.deltaz = self.lz / convert(Float64, (self.nz - 1))

    println(self.deltax)
    println(self.deltay)
    println(self.deltaz)

    for k = 1:self.nz, j = 1:self.ny, i = 1:self.nx
        self.spaceX[i,j,k] = self.deltax*convert(Float64, i-1 ) + self.ox
        self.spaceY[i,j,k] = self.deltay*convert(Float64, j-1 ) + self.oy
        self.spaceZ[i,j,k] = self.deltaz*convert(Float64, k-1 ) + self.oz
    end

end 

end # module GridBlocks 

