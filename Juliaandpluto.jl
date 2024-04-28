### A Pluto.jl notebook ###
# v0.19.41

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 3a93010d-8f6e-482f-b1ff-469b7e358c85
begin
	
	# Code to import required packages to run this notebook
	import Pkg
	Pkg.activate(mktempdir())
	Pkg.add([
			Pkg.PackageSpec(name="PlutoUI", version="0.7"), 
			Pkg.PackageSpec(name="Plots"), 
			Pkg.PackageSpec(name="Colors", version="0.12"),
			Pkg.PackageSpec(name="ColorSchemes", version="3.10"),
			Pkg.PackageSpec(name="LaTeXStrings"),
			])

	using PlutoUI, Plots, Colors, ColorSchemes, LaTeXStrings
	using Statistics, LinearAlgebra  # standard libraries
end

# ╔═╡ f8d70ffb-af63-4e07-a62a-1de2487a6d27
### A Pluto.jl notebook ###
# v0.14.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ b972f6bf-87be-410b-a4d4-7f4e19a2891c
PlutoUI.Resource("https://universidadeuropea.com/resources/static/img/ue-logo.png")

# ╔═╡ 46e47b52-4d27-45b3-aba4-8fa015a468fd
md""" ### _*FLIGHT MECHANICS:*_ STEADY AND LEVEL FLIGHT
V0.0.1"""

# ╔═╡ 6971d9e9-8b07-432d-8a8d-41da2a88070a
Markdown.MD(Markdown.Admonition("danger", "DISCLAIMER.", [md" This notebook is intended *solely for academic purposes*, It **should not be used** in real operational environments or for aircraft design purposes.  Report issues and find the latest version here  [📡](https://github.com/flt-acdesign/Low_speed_AC_performance)  "]))

# ╔═╡ d33d984e-3868-4107-9ede-c5eff03b3f5d
md"### Set Operating Point for calculations ✈  "

# ╔═╡ 55b698f8-4de2-452c-a5c8-68974d4fad64
md" Operating Point:       TAS(m/s) =  $(@bind TAS_op NumberField(1:1:340, default=70))    Altitude(m) =  $(@bind Alt_op NumberField(0:100:20000, default=4000))    Max. Oper. Mach=  $(@bind MMO NumberField(0:.05:1, default=.6))      "

# ╔═╡ 1bd3812a-0736-4194-8d99-214e53bf078c
md"### Define aircraft parameters and status   "

# ╔═╡ 4e68ddda-8d37-4a93-a56a-b73ea8720266
md" Wing area in *m^2* (**Sw**) =  $(@bind Sw NumberField(1:1:1000, default=20))     ······Aircraft maximum lift coefficient (**CLmax**) =  $(@bind CLmax NumberField(0.1:.1:7, default=2))      "

# ╔═╡ 6e5126ce-a4c7-4cd4-a627-ab7c08a1c71c
md" Aircraft mass in *kg* (**M**) =  $(@bind Mass NumberField(0.1:10:600000, default=8000)) ······ **CD0** =  $(@bind CD0 NumberField(0.0:.005:.1, default=.02))   "

# ╔═╡ 63da86e6-0d06-4a44-ab70-4a75e70c4297
md"  Aircraft weight in Newton = $(round(Int, Mass*9.81)) ···· Wing Loading (Kgf/m^2) = $(round((Mass/Sw); digits=1))   "

# ╔═╡ 57785f74-51d8-4ffa-b3e0-946e419977b7
md" **e** =  $(@bind Oswald NumberField(0.1:.01:1.5, default=.85)) ······ **Aspect Ratio** =  $(@bind AR NumberField(1:.1:30, default=10))  "

# ╔═╡ ea5a07d2-2eb7-4e21-a0ae-0d89214eedeb
md"  _**Note: DC stands for 'Drag Count'. where 1 DC is equal to a CD = 1/10000**_"

# ╔═╡ ed33c34a-4d9a-435c-9036-36757eba163f
md"### Aircraft Aerodynamic functions"

# ╔═╡ 7efe802c-f04f-416a-b24f-b594ee3fe449
md"### ISA+0 Atmosphere and units conversion functions"

# ╔═╡ 170898be-9001-4de3-b4e1-ad271930551e
begin

# ISA+0 Atmosphere functions
	
	
# NOTE: the text below, with exactly the format used, corresponds to the Julia "docstrings" standard. The documentation needs to be exactly on the line above the function definition. the "Live docs" button at the bottom right of Pluto will show the documentation of the function when the cursor is over the function name anywhere in the code

	
#_________________________________________________________________________________
"""
    g()

Acceleration of gravity in m/s^2 


# Examples
```julia-repl
julia> g()
9.81
```
"""
g() = 9.81

#_________________________________________________________________________________	
	
	
#_________________________________________________________________________________
"""
    ρ(h)

ISA+0 Density in Kg/m^3 as a function of altitude (h) with h in meters (Troposphere and lower Stratosphere). Note that no error is given if the altitude exceeds the lower stratosphere (20000m), but the results will be invalid.

Note ρ is written with \\rho<tab>
	
from http://nebula.wsimg.com/ab321c1edd4fa69eaa94b5e8e769b113?AccessKeyId=AF1D67CEBF3A194F66A3&disposition=0&alloworigin=1		

# Examples
```julia-repl
julia> ρ(0)
1.225
```
"""
#ρ(h) = 1.225 * (1-0.0000226 * h) ^4.256  # From class notes
	
# From reference above	
	
	
ρ(h) = if h * 3.28084 < 36089
	 1.225 * (1 - h *3.28084/ 145442)^4.255876	
else		
	 1.225 * 0.297076 * exp(-((h*3.28084 -36089)/20806))
end		
#_________________________________________________________________________________
	
	
#_________________________________________________________________________________

"""
    p(h)

ISA+0 Pressure in Pa as a function of altitude (h) with h in meters (Troposphere and lower Stratosphere). Note that no error is given if the altitude exceeds the lower stratosphere (20000m), but the results will be invalid.

from http://nebula.wsimg.com/ab321c1edd4fa69eaa94b5e8e769b113?AccessKeyId=AF1D67CEBF3A194F66A3&disposition=0&alloworigin=1	

# Examples
```julia-repl
julia> p(0)
101325
```
"""	
# p(h) = 101325 * (1-0.0000226 * h) ^5.256 # From class notes
	
p(h) = if h * 3.28084 < 36089
	101325 * (1 - h*3.28084 / 145442)^5.255876	# From reference above
else
	101325 * 0.223361  * exp(-((h*3.28084 -36089)/20806))
end
	
#_________________________________________________________________________________	
	
	
#_________________________________________________________________________________
"""
    T(h)

ISA+0 Temperature in K as a function of altitude (h) with h in meters (Troposphere and lower Stratosphere). Note that no error is given if the altitude exceeds the lower stratosphere (20000m), but the results will be invalid.

from http://nebula.wsimg.com/ab321c1edd4fa69eaa94b5e8e769b113?AccessKeyId=AF1D67CEBF3A194F66A3&disposition=0&alloworigin=1		
	
# Examples
```julia-repl
julia> T(0)
288.16
```
"""		
#T(h) = 288.16 -6.5 * h /1000  # From class notes
T(h) =  if h * 3.28084 < 36089
	288.16*(1 - (h  *3.28084   ) / 145442	)	# From reference above
else
	288.16 * 0.751865
end
#_________________________________________________________________________________	

	
#_________________________________________________________________________________
"""
    μ(h)

Dynamic viscosity in Pa·s as a function of altitude (h) with h in meters, at any altitude

from http://nebula.wsimg.com/ab321c1edd4fa69eaa94b5e8e769b113?AccessKeyId=AF1D67CEBF3A194F66A3&disposition=0&alloworigin=1		
	
# Examples
```julia-repl
julia> μ(0)
1.7894285287902668e-5
```
"""		
μ(h) = 1.458e-6 *T(h)^(3/2) / (T(h) + 110.4) 
#_________________________________________________________________________________	
	

#_________________________________________________________________________________
"""
    Re_m(v, h)

Reynolds number per meter of length as a function of True Air Speed (v) and altitude (h) with h in meters, in Troposphere and lower Stratosphere assuming ISA+0 conditions. Note that no error is given if the altitude exceeds the lower stratosphere (20000m), but the results will be invalid.

	
# Examples
```julia-repl
julia> Re_m(300, 10000)
8.49684500702956e6
```
"""		
	
Re_m(v, h) = ρ(h)	* v / μ(h)
#_________________________________________________________________________________	
	
	
#_________________________________________________________________________________
"""
    a(h)

ISA+0 **speed of sound** in m/s as a function of altitude (**h**) with h in meters at any altitude
	
Note `√` is written with \\sqrt<tab>.

# Examples
```julia-repl
julia> a(0)
340.2626485525556
```
"""			
a(h) = √(1.4*287*T(h))	
#_________________________________________________________________________________
	
		
#_________________________________________________________________________________
"""
    M(TAS, h)

Mach number for a given *True Air Speed (TAS)* in m/s and altitude *h* in meters at any altitude assuming ISA+0 conditions.

# Examples
```julia-repl
julia> M(70,0)
0.20572343246540056
```
"""			
M(TAS, h) = TAS / a(h)
#_________________________________________________________________________________	
	
	
#_________________________________________________________________________________
"""
    q(TAS, h)

ISA+0 **Dynamic pressure (q)** in Pa as a function of True Air Speed in m/s and altitude (**h**) with h in meters at any altitude

# Examples
```julia-repl
julia> q(70,0)
3001.6987513711897
```
"""		
#q(TAS,h) = .5 * ρ(h)* TAS^2   # incompressible formulation

function q(TAS, h)  # compressible formulation
	γ = 1.4   # ratio of heat capacities for air
	return (.5* p(h) * γ * M(TAS,h)^2)
end
#_________________________________________________________________________________
	

#_________________________________________________________________________________
"""
    TAS2EAS(v, h)

Convert a True Air Speed value (in any units) to Equivalent Air Speed (in the same units) assuming ISA+0 conditions.

# Examples
```julia-repl
julia> TAS2EAS(100, 3000)
86.12224886708844
```
"""		
TAS2EAS(v, h) = v * (ρ(h)/ρ(0))^.5
#_________________________________________________________________________________	

	
#_________________________________________________________________________________
"""
    EAS2TAS(v, h)

Convert an Equivalent Air Speed value (in any units) to True Air Speed (in the same units) assuming ISA+0 conditions.

# Examples
```julia-repl
julia> EAS2TAS(100, 3000)
116.11401387616912
```
"""		
EAS2TAS(v, h) = v * (ρ(h)/ρ(0))^-.5
#_________________________________________________________________________________	


#_________________________________________________________________________________
"""
    ms2kt(v)

Convert a speed v from meters per second (m/s) to knots (kt)

# Examples
```julia-repl
julia> ms2kt(1)
1.94384449
```
"""		
ms2kt(v) = 	v*1.94384449
#_________________________________________________________________________________	
	



# **** TODO list ****
	
# Re/m
	
# Add temperature shift
	
	
	
	
	
end	;

# ╔═╡ 1f10fce3-9199-410c-89e7-fe32ca553b31
md"""

TAS(m/s) = $(TAS_op) ······ TAS(kt) = $(round(ms2kt(TAS_op); digits = 1)) ······ 
EAS(m/s) = $(round(TAS2EAS(TAS_op, Alt_op); digits = 1)) ······ 
EAS(kt) =  $(round(ms2kt(TAS2EAS(TAS_op, Alt_op));  digits = 1))

"""

# ╔═╡ 2c23907f-bd6d-4050-bb85-95aa7e7ddf60
md"""

Mach no =  $(round(M(TAS_op, Alt_op); digits = 2))  ······ 
Altitude =  $(string(Alt_op)*" m, ") $(string(round(Int,Alt_op*3.28084))*" ft")  ····
Reynolds per meter (millions) = $( round(Re_m(TAS_op, Alt_op)/1e6; digits = 3) )

"""

# ╔═╡ 43def720-48b2-449d-bdae-4fb4c636219a
begin

# Aircraft aerodynamic coefficients, drag, power required and helper functions
	
	
# NOTE: the text below, with exactly the format used, corresponds to the Julia "docstrings" standard. The documentation needs to be exactly on the line above the function definition. the "Live docs" button at the bottom right of Pluto will show the documentation of the function when the cursor is over the function name anywhere in the code

#_________________________________________________________________________________
"""
    Vs1gTAS(W, h, CLmax, Sw)

Calculate stall speed as TAS at 1g from weight (W) in Newtons, altitude (h) in meters, aircraft maximum lift coefficient (CL) and wing reference area (Sw) in m^2

# Examples
```julia-repl
julia> Vs1gTAS(80000, 4000, 2.1, 20)
48.241248922681834
```
"""
Vs1gTAS(W, h, CLmax, Sw) = ((W)/(ρ(h)*CLmax*Sw))^0.5

#_________________________________________________________________________________

	
#_________________________________________________________________________________
"""
    Vs1gEAS(W, CLmax, Sw)

Calculate stall speed as EAS at 1g from weight (W) in Newtons, aircraft maximum lift coefficient (CL) and wing reference area (Sw) in m^2

# Examples
```julia-repl
julia> Vs1gEAS(80000, 2.1, 20)
39.432317676705956
```
"""
Vs1gEAS(W, CLmax, Sw) = ((W)/(ρ(0)*CLmax*Sw))^0.5

#_________________________________________________________________________________	
	

#_________________________________________________________________________________
"""
    CL(TAS, h, Sw, W) 

Calculate aircraft lift coefficient (CL) from True Air Speed (TAS) in m/s, altitude (h) in m, wing reference area (Sw) in m^2 and aircraft weight (W) in Newtons
	
# Examples
```julia-repl
julia> CL(70, 4000, 70, 80000)
0.569930962682486
```
"""
CL(TAS, h, Sw, W) = W / (.5 * ρ(h) * TAS^2 * Sw)

#_________________________________________________________________________________	
	
	
#_________________________________________________________________________________
"""
    CDi(CL, AR, e)

Calculate aircraft induced drag coefficient (CDi) from aircraft lift coefficient (CL), wing aspect ratio (AR) and Oswald factor (e)
	
# Examples
```julia-repl
julia> CDi(.6, 10, .9)
0.012732395447351627
```
"""
CDi(CL, AR, e) = CL^2 /(π * AR * e)

#_________________________________________________________________________________	

	
#_________________________________________________________________________________
"""
    LD_max(CD0, AR, e)

Calculate aircraft maximum Lift to Drag ratio (L/D max) from aircraft zero lift drag coefficient (CD0), wing aspect ratio (AR) and Oswald factor (e)
	
# Examples
```julia-repl
julia> LD_max(0.02, 10, .9)
26.58680776358274
```
"""
LD_max(CD0, AR, e) = (π*e*AR)^.5 / ( 2*CD0^.5 )
#_________________________________________________________________________________	
	
	
	

#_________________________________________________________________________________
"""
    Drag_induced(TAS, h, Sw, e, W, AR)

Calculate aircraft induced drag in Newtons from true air speed (TAS) in m/s, altitude (h) in meters, wing reference area (Sw) in m^2, Oswald factor (e), aircraft weight (W) in Newtons and wing aspect ratio (AR).
	
# Examples
```julia-repl
julia> Drag_induced(70, 4000, 40, .85, 60000, 10) 
1680.7534663878039
```
"""
Drag_induced(TAS, h, Sw, e, W, AR) = .5 * ρ(h) * TAS^2 * CDi(CL(TAS, h, Sw, W), AR, e) * Sw

#_________________________________________________________________________________		
	
#_________________________________________________________________________________
"""
    Drag_parasitic(TAS, h, CD0, Sw)

Calculate aircraft parasitic drag in Newtons from true air speed (TAS) in m/s, altitude (h) in meters, aircraft zero lift drag coefficient (CD0) and wing reference area (Sw) in m^2.
	
# Examples
```julia-repl
julia> Drag_parasitic(100, 6000, .03, 60)
5929.753076455423
```
"""
Drag_parasitic(TAS, h, CD0, Sw) = .5 * ρ(h) * TAS^2 * CD0 * Sw

#_________________________________________________________________________________		

#_________________________________________________________________________________
"""
    Thrust_required(TAS, h, CD0, Sw, e, W, AR)

Calculate aircraft thrust required for steady and level flight (numerically equal to the total drag = Induced_drag + Parasitic_drag) in Newtons from true air speed (TAS) in m/s, altitude (h) in meters, aircraft zero lift drag coefficient (CD0), wing reference area (Sw) in m^2, Oswald factor (e), aircraft weight (W) in Newtons and wing aspect ratio (AR).
	
# Examples
```julia-repl
julia> Thrust_required(130, 2000, .02, 30, .85, 60000, 10)
5629.534422614251
```
"""
Thrust_required(TAS, h, CD0, Sw, e, W, AR) = Drag_parasitic(TAS, h, CD0, Sw) + Drag_induced(TAS, h, Sw, e, W, AR)

#_________________________________________________________________________________	
	
	
#_________________________________________________________________________________
"""
    Power_required(TAS, h, CD0, Sw, e, W, AR)

Calculate aircraft power required for steady and level flight in Watts from true air speed (TAS) in m/s, altitude (h) in meters, aircraft zero lift drag coefficient (CD0), wing reference area (Sw) in m^2, Oswald factor (e), aircraft weight (W) in Newtons and wing aspect ratio (AR).
	
# Examples
```julia-repl
julia> Thrust_required(130, 2000, .02, 30, .85, 60000, 10)
731839.4749398526
```
"""
Power_required(TAS, h, CD0, Sw, e, W, AR) = TAS * Thrust_required(TAS, h, CD0, Sw, e, W, AR)
#_________________________________________________________________________________	


#_________________________________________________________________________________
"""
    Minimum_power_required(CD0, Sw, e, W, AR, h)

Calculate aircraft minimum power required for steady and level flight in Watts from aircraft zero lift drag coefficient (CD0), wing reference area (Sw) in m^2, Oswald factor (e), aircraft weight (W) in Newtons, wing aspect ratio (AR) and altitude (h) in meters.
	
# Examples
```julia-repl
julia> Minimum_power_required(.02, 30, .85, 60000, 10, 4000)
78760.21221299442
```
"""
Minimum_power_required(CD0, Sw, e, W, AR, h) = 4 * 2^.5 * CD0^.25 * W * 
	( W / (Sw * ρ(h)))^.5 / (3*π*e*AR)^(3/4)
#_________________________________________________________________________________	



#_________________________________________________________________________________
"""
    VMDV(CD0, Sw, e, W, AR, h)

Calculate speed (TAS) for minimum power required, in m/s, from aircraft zero lift drag coefficient (CD0), wing reference area (Sw) in m^2, Oswald factor (e), aircraft weight (W) in Newtons, wing aspect ratio (AR) and altitude (h) in meters.
		
# Examples
```julia-repl
julia> VMDV(0.02, 20, .8, 80000, 10, 1000)
76.56058503076727
```
"""
VMDV(CD0, Sw, e, W, AR, h) = (2/(12 * π * AR * e * CD0)^.25 )   *   (W/(Sw*ρ(h)))^.5
#_________________________________________________________________________________		
	
#_________________________________________________________________________________
"""
    VMD(CD0, Sw, e, W, AR, h)

Calculate minimum drag speed (TAS) in m/s from aircraft zero lift drag coefficient (CD0), wing reference area (Sw) in m^2, Oswald factor (e), aircraft weight (W) in Newtons, wing aspect ratio (AR) and altitude (h) in meters.
		
# Examples
```julia-repl
julia> VMD(0.02, 20, .8, 80000, 10, 1000)
100.7593963754324
```
"""
VMD(CD0, Sw, e, W, AR, h) = (4/(π*AR*e*CD0))^.25*(W/(Sw*ρ(h)))^.5
#_________________________________________________________________________________	
	
	
end;

# ╔═╡ c2532cfc-a080-44c1-a510-b7fb3963f0c2
begin
# calculate global variables of aircraft flight conditions
	
TASstall = 	Vs1gTAS(Mass*9.81, Alt_op, CLmax, Sw) # Stall speed TAS in m/s
EASstall = TAS2EAS(TASstall,  Alt_op) # Stall speed EAS in m/s

TAS_at_MMO = MMO * a(Alt_op) # TAS corresponding to MMO at operating altitude
	
	
AC_CDi = CDi(CL(TAS_op, Alt_op, Sw, Mass*g()) , AR, Oswald) # Aircraft induced drag coefficient
AC_CD = AC_CDi + CD0  # Total aircraft drag coefficient	
	
AC_CL = CL(TAS_op, Alt_op, Sw, Mass*g()) # Aircraft lift coefficient

AC_VMD = VMD(CD0, Sw, Oswald, Mass*g(), AR, Alt_op) # Aircraft minimum drag speed in m/s (TAS)	
	
AC_VMDV = VMDV(CD0, Sw, Oswald, Mass*g(), AR, Alt_op) # Aircraft speed for minimum power required, in m/s (TAS)		
	

AC_min_thrust_required = Thrust_required(AC_VMD, Alt_op, CD0, Sw, Oswald, Mass*g(), AR)	# Aircraft minimum Thrust required for steady and level flight in Newtons
	
AC_power_required_at_min_drag = Power_required(AC_VMD, Alt_op, CD0, Sw, Oswald, Mass*g(), AR)	# Aircraft power required to fly in steady and level flight at the minimum drag TAS speed, in Watts

AC_minimum_power_required = Minimum_power_required(CD0, Sw, Oswald, Mass*g(), AR, Alt_op) 
	
	
AC_LDmax = LD_max(CD0, AR, Oswald)  # Aircraft L/D max	
	
	
end;

# ╔═╡ 9ed500a3-37c5-49c5-8bff-9c301c913a24
begin

TAS_range = 1:5:360  # Define the range of TAS for the x axis (from 1 to 360 in steps of 5)
h_range = [1:250:max(Alt_op+1000, 9000)...] # Define the range of altitudes for the y axis (frfom 1 to 10000 metres in steps of 250m(

	
# Initialize plot	
plot( xticks = 0:50:400, yticks = 0:500:11500, leg=true,
	  grid = (:xy, :olivedrab, :dot, 1, .7) , c= :roma) 

# Draw a contout plot with the dynamic pressure as a function of TAS and Altitude	
plot!(contour(TAS_range, h_range, q, fill = true, c= :coolwarm) )

# Draw a boundary showing the stall speed (TAS) as a function of altitude
plot!(((g()*Mass)./(ρ.(h_range)*CLmax*Sw)).^.5, h_range, label = "Stall speed", lw= 3)

# Draw a reference line for Mach = 0.5 (below it the flow can be assumed incompressible - although there is no incompressible flow in reality). Below, draw additional Mach boundaries corresponding to the maximum operating Mach number (MMO) and M=1 as lines for reference
plot!((0.5.*a.(h_range))  , h_range, label = "M = 0.5", lw= 1)
plot!((MMO.*a.(h_range))  , h_range, label = "MMO = "*string(MMO), lw= 2)
plot!((1.0.*a.(h_range))  , h_range, label = "M = 1", lw= 3, c=:red)
	
# Draw a circle showing the operating point under study
scatter!([TAS_op],[Alt_op], label = "Operating Point", ms = 4)	
# Draw a label on the operating point
annotate!([TAS_op]  ,[Alt_op+300], Plots.text("✈", 14, (TAS_op > TASstall ? :yellow : :red), :left))
# Draw values of the operating point	
annotate!([TAS_op]  ,[Alt_op-300], Plots.text("TAS(kt)= "*string(TAS_op), 8, :yellow, :left))	
annotate!([TAS_op]  ,[Alt_op-700], Plots.text("h(m)= "*string(Alt_op), 8, :yellow, :left))		
annotate!([TAS_op]  ,[Alt_op-1100], Plots.text("q(Pa)= "*string(round(Int,q(TAS_op, Alt_op))), 8, :yellow, :left))
annotate!([TAS_op]  ,[Alt_op-1500], Plots.text("CL= "*string(round(AC_CL; digits = 2)), 8, :yellow, :left))	
	

# Draw a circle showing the stall speed at the operating altitude
scatter!([TASstall],[Alt_op], label = "Stall speed kt(TAS)", ms = 4)	
# Draw a label with the stall speed at this altitude, rounded to 1 decimal place and converted to knots (1m/2 = 1.94384 kt)
annotate!([TASstall+15]  ,[Alt_op+200], Plots.text(string(round((ms2kt(TASstall)); digits=1))*" kt", 8, :orange, :center))
	
# Define plot name and axis labels	
xlabel!("TAS (m/s)")  # Set label for x axis
ylabel!("Altitude (m)")  # Set label for y axis
title!("Dynamic pressure contour with stall and Mach boundaries")
	
plot!(size=(660, 400), legend=:bottomright)	# Update plot attributes

end

# ╔═╡ efe6430a-5e3f-45f8-861d-bf835e00c0b6
md" Aircraft CDi(DC) = $(round(Int, 10000*AC_CDi)) ······ Aircraft CD0(DC) = $(round(Int, 10000*CD0))  ······ Aircraft CD(DC) = $(round(Int, 10000*AC_CD)) "

# ╔═╡ 14027a80-5a37-4259-9157-783615ff40fe
md" Stall speeds ······ TAS =  $(round(TASstall; digits = 1))(m/s)    $(round(ms2kt(TASstall); digits = 1))(kt)               ······  EAS =  $(round(EASstall; digits = 1)) (m/s)  $(round(ms2kt(EASstall); digits = 1))   (kt)          "

# ╔═╡ 3c8103bb-f07d-4f17-a872-d0bfce72dad5
md"""

Minimum Thrust required = $(string(round(Int, AC_min_thrust_required))*" N") 
at $(string(round(AC_VMD; digits = 1))*" m/s (TAS,)")  
$(string(round(ms2kt(AC_VMD); digits = 1))*" kt(TAS), ")  
$(string(round(ms2kt(TAS2EAS(AC_VMD, Alt_op)); digits = 1))*" KEAS, ") 

"""

# ╔═╡ abaa88f2-33a0-4414-831c-5892f89bd083
md"""

Maximum L/D = $(string(round(AC_LDmax; digits = 2))*" ") 
at $(string(round(AC_VMD; digits = 1))*" m/s (TAS,)")  
$(string(round(ms2kt(AC_VMD); digits = 1))*" kt(TAS), ")  
$(string(round(ms2kt(TAS2EAS(AC_VMD, Alt_op)); digits = 1))*" KEAS, ") 

"""

# ╔═╡ 4063f6c0-1e88-4116-b923-a58e37742b56
md"""

Minimum Power Required = $(string(round(Int, AC_minimum_power_required))*" W") 
at $(string(round(AC_VMDV; digits = 1))*" m/s (TAS,)")  
$(string(round(ms2kt(AC_VMDV); digits = 1))*" kt(TAS), ")  
$(string(round(ms2kt(TAS2EAS(AC_VMDV, Alt_op)); digits = 1))*" KEAS, ") 

"""

# ╔═╡ afcbfa3e-ef58-44f0-99ee-4c1464305949
begin
	
plot(xticks = 0:10:350, 
	 yticks = 0:max(round(Int, AC_min_thrust_required/4),1):AC_min_thrust_required*50, leg=true, size=(660, 400),
     grid = (:xy, :olivedrab, :dot, .5, .8)) # Initialize plot with basic parameters
	
	
	# Plotting the data
v1 = (TASstall:1:TAS_at_MMO)   # Define range of TAS speeds in x axis; from stall speed to TAS corresponding to maximum operating Mach number

	
plot!(v1, Drag_parasitic.(v1, Alt_op, CD0, Sw), label = "D_parasitic (N)", linewidth =3)

plot!(v1, Drag_induced.(v1, Alt_op, Sw, Oswald, Mass*9.81, AR) , label = "D_Induced(N)", linewidth =3)
	
plot!(v1, (Drag_parasitic.(v1, Alt_op, CD0, Sw) + Drag_induced.(v1, Alt_op, Sw, Oswald, Mass*9.81, AR))      , label = "Thrust Required (N)", linewidth =3)

	
# Draw a circle showing the minimum thrust required
scatter!([AC_VMD],[AC_min_thrust_required], label = "Min. thrust req.", ms = 4)		

annotate!([AC_VMD]  ,[AC_min_thrust_required*1.1], Plots.text("T = "*string(round(Int, AC_min_thrust_required))*" N", 8, :black, :left))	

annotate!([AC_VMD]  ,[AC_min_thrust_required*1.2], Plots.text("TAS = "*string(round(Int, AC_VMD))*" m/s", 8, :black, :left))
	
	
		
# Final plot attributes
xlabel!("TAS (m/s)")  # Set label for x axis
ylabel!("Thrust required (N)")  # Set label for y axis (wrt: "with respect to")
title!("Thrust required for steady and level flight at $(Alt_op) m")
	
plot!()  # Update plot with all of the above
	
end

# ╔═╡ 477e96e2-2cf6-49ba-9957-0b27a047a5f1
begin
	
plot( xticks = 0:10:350, yticks = 0:10:100, leg=true, size=(660, 300),grid = (:xy, :olivedrab, :dot, .5, .8)     ) # Initialize plot with some basic parameters
	
# Plotting the data
v2 = (0:1:80)   # Define range of TAS speeds in x axis; from stall speed to TAS corresponding to maximum operating Mach number

plot!(v2, (CL.(v2, Alt_op, Sw, Mass*g()))./(  (CD0 .+ CDi.(CL.(v2, Alt_op, Sw, Mass*g() ) , AR, Oswald))    )       , label = "L/D", linewidth =3)

# Draw a circle showing the minimum thrust required
scatter!([AC_VMD],[AC_LDmax], label = "L/D max", ms = 4)	

annotate!([AC_VMD]  ,[AC_LDmax*.99], Plots.text("L/Dmax= "*string(round(AC_LDmax;digits = 1)), 8, :black, :left))	

annotate!([AC_VMD]  ,[AC_LDmax*0.94], Plots.text("@TAS = "*string(round(Int, AC_VMD))*" m/s", 8, :black, :left))
	
		
# Final plot attributes
xlabel!("TAS (m/s)")  # Set label for x axis
ylabel!("L/D")  # Set label for y axis (wrt: "with respect to")
title!("Aircraft Lift to Drag ratio")
	
plot!(legend=:bottomright)  # Update plot with all of the above
	
end

# ╔═╡ c2d2bfd4-2676-46e9-ae1b-5bf40e818236
begin
	
plot(xticks = 0:10:350, 
	 yticks = 1:round(Int, AC_minimum_power_required/4):AC_minimum_power_required*50, leg=true, size=(660, 400),
	 grid = (:xy, :olivedrab, :dot, .5, .8)) # Initialize plot with basic parameters
	
# Plotting the data
v3 = (TASstall:1:TAS_at_MMO)   # Define range of TAS speeds in x axis; from stall speed to TAS corresponding to maximum operating Mach number

# Draw curve of power required at the operating altitude
plot!(v3, Power_required.(v3, Alt_op, CD0, Sw, Oswald, Mass*g(), AR)         , label = "PR", linewidth =3)

# Draw a circle showing power required at the minimum drag speed
scatter!([AC_VMD],[AC_power_required_at_min_drag], label = "PR at VMD", ms = 4)	
# Plot tangent from origin
plot!([0,AC_VMD], [0,AC_power_required_at_min_drag], label = "Tangent from origin", linewidth =2, line = :dashdot)
# Add annotation with value of power required at VMD
annotate!([AC_VMD+2]  ,[AC_power_required_at_min_drag*.96], Plots.text(string(round(Int, AC_power_required_at_min_drag))*" W", 8, :black, :left))		
	
	
# Draw a circle showing minimum power required	
scatter!([AC_VMDV],[AC_minimum_power_required], label = "PR min", ms = 4)	
	
# Add annotation with value of minimum power required
annotate!([AC_VMDV+2]  ,[AC_power_required_at_min_drag*.96], Plots.text(string(round(Int, AC_minimum_power_required))*" W", 8, :black, :left))
	
		
# Final plot attributes
xlabel!("TAS (m/s)")  # Set label for x axis
ylabel!("Power required (W)")  # Set label for y axis (wrt: "with respect to")
title!("Aircraft Power Required (PR) for steady and level flight")
	
plot!(legend=:bottomright)  # Update plot with all of the above
	
end

# ╔═╡ dc2a4c51-b390-41df-9d22-8c31c1e92272
begin
	
	plot( xticks = 0:1000:20000, yticks = 0:10:100, leg=true, size=(1360, 800),grid = (:xy, :olivedrab, :dot, .5, .8)     ) # Initialize plot with some basic parameters
	
	# Plotting the data
	h1 = (1:500:20000)   # Define series for x axis (from 0 to 10000 in steps of 500)
	
	# Draw lines for relative density, pressure, speed of sound and T
	plot!(h1, p.(h1)./p(0)*100, label = "p(h)/p(0) %", linewidth =2)
	plot!(h1, ρ.(h1)./ρ(0)*100, label = "ρ(h)/ρ(0) %", linewidth =2)
	plot!(h1, a.(h1)./a(0)*100, label = "a(h)/a(0) %", linewidth =2)
	plot!(h1, T.(h1)./T(0)*100, label = "T(h)/T(0) %", linewidth =2, line = :dashdot)
	
	# Draw line at operating altitude
	plot!([Alt_op,Alt_op], [0,100], label = "Operating altitude", linewidth =2, line = :dashdot)
	
	
	# Final plot attributes
	xlabel!("h (m)")  # Set label for x axis
	ylabel!("% wrt MSL values")  # Set label for y axis (wrt: "with respect to")
	title!("% (value at altitude / value at MSL) of ISA quantities")
	
	plot!()  # Update plot with all of the above
	
end

# ╔═╡ cf7ea2fd-5fc6-457f-86f7-9673a1f5ec03
begin
# Cálculo de Vc
Vc = ((5 .- (Drag_parasitic(velo, Alt_op, CD0, Sw) + 
            Drag_induced(velo, Alt_op, Sw, 0.8, Mass * 9.81, AR)))/2)

# Pendiente entre (0,0) y cada punto (velo, Vc)
pendientes = Vc ./ velo

# Encuentra la pendiente máxima
pendiente_max = maximum(pendientes)

# Índice de la velocidad con la pendiente máxima
indice_max = argmax(pendientes)

# Velocidad y Vc correspondientes a la pendiente máxima
velocidad_max = velo[indice_max]
Vc_max = Vc[indice_max]

# Imprime la pendiente máxima
println("La pendiente máxima es: ", pendiente_max)

# Plotea Vc vs velo (línea original en azul)
plot(velo, Vc, label="Vc vs velo", linewidth=3, color=:blue)

# Dibuja la línea con la pendiente máxima (en rojo, desde el origen al punto con pendiente máxima)
plot!([0, velocidad_max], [0, Vc_max], label="Pendiente máxima", color=:red, linewidth=2, linestyle=:dash)

# Etiquetas y título
xlabel!("Velocidad (m/s)")
ylabel!("Vc")
title!("Vc vs Velocidad con Pendiente Máxima")

# Mostrar la gráfica
display(plot())
end

# ╔═╡ 1e7dcb76-aa9e-4523-bd3a-9a03c03522ef
md" 🌍 Graphics showing relative variation with respect to Mean Sea Level (MSL) values of pressure, density and temperature with altitude in ISA+0 conditions in troposphere"

# ╔═╡ 4e2e00ba-8384-4364-9b59-117946ef4a1b
md" The code below this point is to set-up the notebook"

# ╔═╡ 53a89066-30f9-42bf-b3bc-d9ba4c22f9f1
md"""
> [***For help with plots follow this link***](http://docs.juliaplots.org/latest/tutorial/) (and then come back to the Pluto notebook)
"""

# ╔═╡ c142198b-e100-455f-9190-a6d27a573c72
TableOfContents(aside=true) # Show table of contents

# Cell order:
# ╟─d7356e75-d9d5-495c-b661-57864583ae61
# ╟─ea326e95-0585-41f4-9cb2-da90b680f788
# ╟─f384cb30-50af-4ad5-8986-2e11ed5a5e1d
# ╟─6f320fcf-346d-4260-ad63-36269b9de1eb
# ╟─addf6fa0-3335-4250-9dcb-eb9e3e87b4af
# ╟─19816267-988f-45d5-8c39-bedc11d76e12
# ╟─29124d03-7ae5-49f1-8aff-272bc9f3d5cd
# ╟─ce4bf0a4-97c8-4bf0-9140-d1ff3f05410c
# ╟─304934d3-cf2e-443c-8c42-74940e584160
# ╟─d79c73d4-9889-4feb-8eb8-58583dfcc04c
# ╟─22aa1e3d-5265-4e35-90bb-b146954efcf5
# ╟─de07547d-4c70-4793-96f2-8dfb2379ac54
# ╟─98eeefa9-5c98-4c1c-9d00-f494d3eb095a
# ╟─508a4cb4-5b8b-40b2-a8bd-33f761a06281
# ╟─701806df-20fe-4181-b9d0-789f0d4a9944
# ╟─876054ed-76df-4865-8cea-a918bec4bbdb
# ╟─c755a5f9-8e92-4612-bfa1-ec543cd66d97
# ╟─eda69bea-39a4-4d72-ba7b-302d5f1a9182
# ╟─887e79e9-c63b-4c52-ade5-44a0bcfdfcf8
# ╟─82a8227c-489a-4c53-ad5e-cc97555f43f7
# ╟─2b985fdb-f11c-4d23-8708-516fc9a64cf4
# ╟─d243b143-428a-4939-9f7f-b995254f45e0
# ╟─ef4b7a28-6877-4d9b-b966-a71eb2e71f3e
# ╟─b4160b27-8180-4446-bd2c-a0551bd2a9d1
# ╟─ae28f744-625b-4fac-a8d2-c74855c752ea
# ╟─bef4363e-34ef-499b-85cc-eead54a8ede2
# ╟─27007d5a-6f85-4ff4-9185-ab1e0df69eea
# ╟─13b762d4-366a-47a5-ad77-a18e2b187b78
# ╟─a57e579f-5c6e-48f6-a390-2d3b7b816372
# ╟─5afceffa-6e23-422e-81ee-4aee76899d93
# ╟─8b1ccfb8-6b6c-4caa-823f-b16b59eee635
# ╟─7693366f-2c0c-4be3-be85-e2d7d7591977
# ╟─4839b8b3-b070-4510-ad09-0a43bfc35a25
# ╟─20454a26-4719-4c30-9e46-483c27eb630d

# ╔═╡ Cell order:
# ╠═f8d70ffb-af63-4e07-a62a-1de2487a6d27
# ╠═3a93010d-8f6e-482f-b1ff-469b7e358c85
# ╠═b972f6bf-87be-410b-a4d4-7f4e19a2891c
# ╠═46e47b52-4d27-45b3-aba4-8fa015a468fd
# ╠═6971d9e9-8b07-432d-8a8d-41da2a88070a
# ╠═d33d984e-3868-4107-9ede-c5eff03b3f5d
# ╠═55b698f8-4de2-452c-a5c8-68974d4fad64
# ╠═1bd3812a-0736-4194-8d99-214e53bf078c
# ╠═4e68ddda-8d37-4a93-a56a-b73ea8720266
# ╠═6e5126ce-a4c7-4cd4-a627-ab7c08a1c71c
# ╠═63da86e6-0d06-4a44-ab70-4a75e70c4297
# ╠═57785f74-51d8-4ffa-b3e0-946e419977b7
# ╠═ea5a07d2-2eb7-4e21-a0ae-0d89214eedeb
# ╠═ed33c34a-4d9a-435c-9036-36757eba163f
# ╠═7efe802c-f04f-416a-b24f-b594ee3fe449
# ╠═170898be-9001-4de3-b4e1-ad271930551e
# ╠═1f10fce3-9199-410c-89e7-fe32ca553b31
# ╠═2c23907f-bd6d-4050-bb85-95aa7e7ddf60
# ╠═43def720-48b2-449d-bdae-4fb4c636219a
# ╠═c2532cfc-a080-44c1-a510-b7fb3963f0c2
# ╠═9ed500a3-37c5-49c5-8bff-9c301c913a24
# ╠═efe6430a-5e3f-45f8-861d-bf835e00c0b6
# ╠═14027a80-5a37-4259-9157-783615ff40fe
# ╠═3c8103bb-f07d-4f17-a872-d0bfce72dad5
# ╠═abaa88f2-33a0-4414-831c-5892f89bd083
# ╠═4063f6c0-1e88-4116-b923-a58e37742b56
# ╠═afcbfa3e-ef58-44f0-99ee-4c1464305949
# ╠═477e96e2-2cf6-49ba-9957-0b27a047a5f1
# ╠═c2d2bfd4-2676-46e9-ae1b-5bf40e818236
# ╠═dc2a4c51-b390-41df-9d22-8c31c1e92272
# ╠═cf7ea2fd-5fc6-457f-86f7-9673a1f5ec03
# ╠═1e7dcb76-aa9e-4523-bd3a-9a03c03522ef
# ╠═4e2e00ba-8384-4364-9b59-117946ef4a1b
# ╠═53a89066-30f9-42bf-b3bc-d9ba4c22f9f1
# ╠═c142198b-e100-455f-9190-a6d27a573c72