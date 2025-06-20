### A Pluto.jl notebook ###
# v0.20.10

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ a148dbaa-4d96-11f0-0a70-376c51e25d24
using PlutoUI, CoolProp, Plots;

# ╔═╡ 0a66fc8c-d81d-4960-bec8-c21b965a393e
md"""
#### Selecciona la presión de la Caldera en MPa
"""

# ╔═╡ ef86afb8-234a-41ef-9b7d-ce5449f6cb43
@bind P_boiler Slider(1.0:0.5:20.0, show_value=true) # Presión caldera [MPa]


# ╔═╡ ec176b4e-088c-4a19-ae80-c5dbdb70d4a8
md"""
#### Selecciona la presión en el consensador en kPa
"""

# ╔═╡ dafa8176-7213-4d6d-89a2-51c0387ab0e6
@bind P_condensador Slider(1.0:0.5:80, show_value=true) # Presión condensador [MPa]


# ╔═╡ e162361c-8f45-4beb-83a9-73a11eefa561
md"""
#### Dame la temperatura a la entrada de la turbina en °C
"""

# ╔═╡ 94ec04c9-1267-4767-81a9-d6e3846196fc
@bind T3_text TextField(default="500.0")

# ╔═╡ 175696a6-4929-43d7-b57c-b2ce3935b86a
begin
T3_true = (T3_text == "") ? "10.0" : T3_text
T3_C = tryparse(Float64, T3_true)

end

# ╔═╡ ed3b01c5-f568-4a85-ba6f-803a8a31488b
begin
	fluido = "Water"

	P1 = P_condensador * 1e3  # Pa
	P2 = P_boiler * 1e6       # Pa

	h1 = PropsSI("H", "P", P1, "Q", 0, fluido)
	s1 = PropsSI("S", "P", P1, "Q", 0, fluido)

	h2s = PropsSI("H", "P", P2, "S", s1, fluido)
	η_bomba = 1#0.85
	h2 = h1 + (h2s - h1)/η_bomba

	T3_sat = PropsSI("T", "P", P2, "Q", 1, fluido)
	
    T3_K = T3_C + 273.15
	
	if (T3_K > T3_sat) 

		T_3 = T3_K
	    h3 = PropsSI("H", "P", P2, "T", T_3, fluido)
	    s3 = PropsSI("S", "P", P2, "T", T_3, fluido)
		
	else
        T_3 = T3_sat
		h3 = PropsSI("H", "P", P2, "Q", 1.0, fluido)
	    s3 = PropsSI("S", "P", P2, "Q", 1.0, fluido)
	end
	

	h4s = PropsSI("H", "P", P1, "S", s3, fluido)
	η_turbina = 1#0.85
	h4 = h3 - η_turbina*(h3 - h4s)

	# Energías
	w_bomba = h2 - h1
	q_hervidor = h3 - h2
	w_turbina = h3 - h4
	q_condensador = h4 - h1

	η_termica = (w_turbina - w_bomba) / q_hervidor
	
	
	 T_3 -273.15, T3_sat-273.15
end

# ╔═╡ bb1dca42-21c7-4587-873d-be577c8cf87a
begin
	srange = LinRange(300,647.08, 200)
	Tf = collect(srange)
	sf = similar(Tf)
	sg = similar(Tf)
    sf = PropsSI.("S", "T", Tf, "Q", 0, fluido)
	sg = PropsSI.("S", "T", Tf, "Q", 1, fluido)
	T1 = PropsSI("T", "P", P1, "Q", 0, fluido)
	T2 = PropsSI("T", "P", P2, "H", h2, fluido)
 	T3 = T_3#PropsSI("T", "P", P2, "Q", 1, fluido)
 	T4 = PropsSI("T", "P", P1, "H", h4, fluido)
 	s2 = PropsSI("S", "P", P2, "H", h2, fluido)
	s4 = PropsSI("S", "P", P1, "H", h4, fluido)

	s23ran = LinRange(s2,s3, 500)
	s23 = collect(s23ran)
	T23 = similar(s23)
    T41 = similar(s23)
	T23 = PropsSI.("T", "P", P2, "S", s23, fluido)
    T41 = PropsSI.("T", "P", P1, "S", s23, fluido)
	

 	S = [s1, s2, s3, s4, s1]
 	T = [T1, T2, T3, T4, T1]



	plot(sf, Tf.-273.15, lw=3,color=:black,  label=:false)
	plot!(sg, Tf.-273.15, lw=3, color=:black, label=:false)

	plot!(s23, T23.-273.15, lw=3, color=:red, label=:false)
    plot!(s23, T41.-273.15, lw=3, color=:blue, label=:false)
	scatter!([4407],[647.1].-273.15, color=:black,label=:false)
	plot!([s3,s3], [T3, T4] .- 273.15, color=:green, lw=3, label=:false)
	plot!([s1,s1], [T1, T2] .- 273.15, color=:yellow, lw=3, label=:false)
		scatter!(S, T.-273.15, label=:false, xlabel="Entropía [J/kg·K]", ylabel="Temperatura [°C]", lw=2, marker=:circle, ylims=(10, 850)
			, xlims=(500, 8500))
end

# ╔═╡ 01f94e8f-7c16-4c0d-bf3f-beb87fac648d
md"""
### 🔍 Resultados del ciclo Rankine
- **Presión en caldera:** $(round(P_boiler, digits=2)) MPa  
- **Presión en condensador:** $(round(P_condensador, digits=3)) kPa  
- **Trabajo de la turbina:** $(round(w_turbina/1000, digits=2)) kJ/kg  
- **Trabajo de la bomba:** $(round(w_bomba/1000, digits=2)) kJ/kg  
- **Calor agregado en la caldera:** $(round(q_hervidor/1000, digits=2)) kJ/kg  
- **Rendimiento térmico:** $(round(η_termica*100, digits=2)) %
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CoolProp = "e084ae63-2819-5025-826e-f8e611a84251"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
CoolProp = "~0.2.1"
Plots = "~1.40.13"
PlutoUI = "~0.7.63"
"""


# ╔═╡ Cell order:
# ╟─a148dbaa-4d96-11f0-0a70-376c51e25d24
# ╟─0a66fc8c-d81d-4960-bec8-c21b965a393e
# ╟─ef86afb8-234a-41ef-9b7d-ce5449f6cb43
# ╟─ec176b4e-088c-4a19-ae80-c5dbdb70d4a8
# ╟─dafa8176-7213-4d6d-89a2-51c0387ab0e6
# ╠═e162361c-8f45-4beb-83a9-73a11eefa561
# ╟─94ec04c9-1267-4767-81a9-d6e3846196fc
# ╟─175696a6-4929-43d7-b57c-b2ce3935b86a
# ╟─ed3b01c5-f568-4a85-ba6f-803a8a31488b
# ╟─bb1dca42-21c7-4587-873d-be577c8cf87a
# ╟─01f94e8f-7c16-4c0d-bf3f-beb87fac648d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
