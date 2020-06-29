---
title: "A first-order flexible ELA model based on geomorphic constraints"
author: 
- Durban G. Keeler
#  affiliation: Department of Geography, University of Utah, Salt Lake City, UT USA
- Summer Rupper
#  affiliation: Department of Geography, University of Utah, Salt Lake City, UT USA
- Joerg Schaefer
#  Lamont-Doherty Earth Observatory, Columbia University, Palisades, NY USA
bibliography: [citations.bib]
csl: methodsx.csl
geometry: margin=1in
md_extensions: +grid_tables +table_captions
---

## Abstract

Alpine glaciers, with their valuable combination of highly sensitive response to climate and near-global extent, are powerful tools for investigating previous and present climate changes.
They also represent critical water resources for areas around the globe, with the potential for far-reaching effects in a warming world.
Advancements to understand and model glacial changes and the variables influencing them are therefore paramount.
Many glacier models fall into one of two endmembers: either highly complex transient models requiring careful tuning of multiple parameters to individual glaciers, or basic empirical correlations of glacier area and length with few considerations for local and regional variations in characteristics.
Here we detail a physical steady-state model for alpine glaciers relating directly to glacier mass balance (via the equilibrium line altitude) while retaining the simplicity of other morphology methods, and simultaneously including error estimates.
We provide custom MATLAB functions as a user-friendly and generally-applicable method to estimate glacier equilibrium line altitudes from only a limited number of glacier bed topography and glacier width measurements.
As a test of the model’s efficacy, we compare the model results for present-day glaciers in the Swiss Alps with previously published estimates of equilibrium line altitudes and intermediate model outputs.

## Graphical abstract

![Graphical abstract describing the ELA modeling process used in this study.](Figures/graph-abstract.png)

## Methodology

Changes in glacier size and extent are fundamentally related to the mass balance of the glacier.
An annual mass surplus (when net accumulation exceeds ablation) leads to glacier growth, while a deficit leads to glacier retreat.
Such transitions can be visually drastic, with some glaciers changing by kilometers in response to minor perturbations in climate.
A more comparable measure of the glacier response to climate change than glacier area or length changes is the concept of the equilibrium line altitude (ELA).
The ELA is the boundary between the accumulation and ablation zones on a glacier and represents the elevation at which the annual amount of mass added through accumulation exactly equals the annual amount of mass lost through ablation [@cuffey_physics_2010].
As a direct measure of glacier mass balance, the ELA facilitates explicit comparisons of climate in space and time by accounting for dependencies on glacier size, extent, and shape, and by integrating the myriad variables that can drive changes in climate into a single metric.

This manuscript presents a method to reconstruct ELA estimates based on continuity equations, while only requiring estimates of bed topography, glacier length, and glacier width.
The ELA model also generates intermediate results of continuous modeled bed topography, ice surface elevation, and glacier width along the length of the glacier (Figure 1).
An added strength of this model is that such intermediate outputs allow for increased diagnostics on model performance or troubleshooting.
This ELA model is similar in simplicity to field-based, geomorphic methods such as the toe-to-head area ratio (THAR) or accumulation area ratio (AAR) [@benn_mass_2000], but based on continuity equations rather than relying purely on empirical correlations, while also accounting for physical errors in measurements.
This method can equally apply to existing glaciers or paleo-glacier extents where glacial moraines are adequately preserved.
The model is largely derived from a simple linear glacier-length model presented in [@oerlemans_minimal_2008], with modifications specific to quantifying ELAs and ELA changes.
The limited model inputs necessarily require simplifying assumptions that do not include all details pertinent to specific glaciers.
Such details can be significant for some applications (e.g. dynamic modeling of glacier response, higher order surface energy and mass balance modeling, etc.), and other methods would be better suited to these circumstances.
The proposed model is specifically intended to estimate the ELA of snow-fed, clean ice, temperate glaciers with relatively simple bed and areal geometries.

The ELA model also provides analytical constraints on the error associated with model outputs.
Such uncertainties are fundamental in determining the significance and reliability of results, but rigorous physical uncertainties of ELA estimates are rarely presented in paleo-glacier research, either because such uncertainties are difficult to assign for geomorphic methods like THAR and AAR or because higher order models are sufficiently complex to challenge error propagation.
Uncertainty estimates in this study are calculated based on Monte Carlo simulations of bootstrapped residuals of the input parameters.
These uncertainties give insight into the range of plausible ELA values based on both uncertainty of input parameters and the ability of the model assumptions to accurately represent those inputs.

### Balance equation

The fundamental basis of the ELA model is an integrated balance formula (Equation \ref{eq:balance}) for steady-state glaciers from @oerlemans_minimal_2008,

\begin{equation}
\label{eq:balance}
B_n = \int_0^L \dot{b}dx = \beta \int_0^L \left[ w(x) \left( H(x)+z(x)-ELA \right) \right]dx
\end{equation}

where $B_n$ is the total net balance, $x$ is the distance down glacier, $\dot{b}$ is the specific balance rate at $x$, $L$ is the glacier length, $\beta$ is the balance gradient, $w(x)$ is the glacier width at $x$, $H(x)$ the ice thickness at $x$, $z(x)$ represents the valley topography, and $ELA$ is the equilibrium line altitude.
In steady state conditions (like we assume for glaciers with well-developed moraine sequences), the total net balance is zero.
The balance gradient $\beta$ can be dropped in this case, and Equation \ref{eq:balance} can then be adapted to solve for the $ELA$ (Equation \ref{eq:ela}).

\begin{equation}
\label{eq:ela}
ELA = \frac{\int_0^L w(x) H(x)dx + \int_0^L w(x) z(x)dx}{\int_0^L w(x) dx}
\end{equation}

We then estimate each of the three components ($H(x)$, $w(x)$, and $z(x)$) along the length of the glacier and solve for each component using trapezoidal numerical integration to derive an estimate for $ELA$.
Methods for the estimation of each of these components are detailed below.

### Glacier bed modeling

Bed topography measurements follow a representative 1D line along the glacier profile taken down the center of the glacier.
We then estimate $z(x)$ from a best-fit two-term exponential curve of this 1D profile line (Equation \ref{eq:bed}), where $a$, $b$, $c$, and $d$ are fitting coefficients optimized in the model using the elevation data inputs (see Figure 3 for examples).
Optimizations in this ELA model use nonlinear least squares regression based on *trust region* algorithms [@more_computing_1983].

\begin{equation}
\label{eq:bed}
z(x) = ae^{bx} + ce^{dx}
\end{equation}

This two-term exponential estimate is best suited for valleys with relatively simple bed topographies.
Caution should be used when applying this method to glacier beds with more complex bed features, such as steep cliffs or over deepenings, as these are not always readily captured in the model.

### Ice thickness modeling

To first order, the thickness of a glacier depends largely on the slope and shear stress at the bed [@cuffey_physics_2010].
The simplest equation to approximate ice thickness is therefore

\begin{equation}
\label{eq:ice0}
H = \frac{\tau}{\rho g \sin\theta}
\end{equation}

where $H$ is the ice thickness (m), $\tau$ is the basal shear stress (Pa), $\rho$ is the ice density ($\:kg/m^3$), $g$ is acceleration due to gravity ($\:m/s^2$), and $\theta$ is the angle at the bed interface [@cuffey_physics_2010].
In areas with shallow slopes, however, Equation \ref{eq:ice0} leads to ice thickness unrealistically approaching infinity.
@oerlemans_minimal_2008 demonstrates a square root relation between length and ice thickness (assuming perfect plasticity), which we incorporate into our estimates in order to address this issue.

\begin{equation}
\label{eq:ice-thick}
H_m = \frac{2}{3} \sqrt{\frac{\tau L}{\rho g \left( 1+\sin\theta \right)}}
\end{equation}

Equation \ref{eq:ice-thick}, however, gives the mean ice thickness ($H_m$) for the glacier, rather than continuous values along its length.
To model ice thickness profiles, we assume a parabolic distribution (true of a perfectly plastic glacier on a flat bed) around the mean ice thickness (see Figure 4 for examples).
The basal shear stress ($\tau$) is assumed to scale with ice thickness, following the relationship presented in [@haeberli_application_1995] (Equation \ref{eq:tau}), where $\Delta z$ is the difference between the minimum and maximum bed elevation.

\begin{equation}
\label{eq:tau}
\begin{split}
\Delta z > 1600 \:m \Longrightarrow \tau = 150 \:kPa \\
500 \:m \le \Delta z \le 1600 \:m \Longrightarrow \tau = 0.005 + 1.598\Delta z - 0.435\Delta z^2 \:kPa \\
\Delta z < 500 \:m \Longrightarrow \tau = 3\Delta z \:kPa
\end{split}
\end{equation}

### Glacier width modeling

Due to the high diversity in glacier shape/geometry, estimating the plan-view profile of the glacier in a consistent yet simple manner is difficult.
Additionally, accurately constraining the width of the accumulation area for paleoglaciers presents further challenges, due to a lack of preserved moraines or other features delineating glacier boundaries in these areas.
To best cope with these issues, we estimate glacier width using an exponential formula (Equation \ref{eq:width}) of the same form as presented in @oerlemans_minimal_2008.
The initial starting parameters are the minimum width of the glacier at the toe ($w0$), maximum glacier width in the accumulation zone ($w_{max}$), the distance down glacier ($x$), and the distance down glacier to the point of maximum width ($L_{Wmax}$).

\begin{equation}
\label{eq:width}
w(x) = w_0 + \frac{w_{max}-w_0}{L_{Wmax}}xe^{1-\frac{x}{L_{Wmax}}}
\end{equation}

This produces an exponential curve, following the general shape of many glaciers.
The model then performs least squares nonlinear curve fitting (again based on trust region techniques) on the initial parameter estimates to optimize the fit to the input width estimates (see Figure 5 for examples).

The model can also incorporate glacier tributaries.
The tributaries are intially modeled as independent glaciers, including profile centerline elevations and width measurements.
The calculated tributary glacier volume is then added to the main glacier at corresponding elevation levels as additional modeled glacier width.
Added caution should be exercised with this model when including tributary glaciers, as the glacier plan profile can depart more severely from the assumed idealized shape constraints.

### Monte Carlo simulations

We perform Monte Carlo simulations to capture the distribution of plausible ELAs for a given glacier.
Such estimation of uncertainty is important to adequately compare the significance of results, particularly if attempting to compare results from differing methodologies or between regions.
Monte Carlo methods are widely used in modeling of glacier mass and energy balance for uncertainty estimation [@machguth_exploring_2008].
In our approach, we perform bootstrapping with replacement techniques to incorporate the uncertainty of input parameters and to include any known errors in those parameters, assuming Gaussian error distributions.
Each model run consists of 1,000 simulations in order to approximate a continuous distribution in plausible ELA values.

## Data and analysis workflow

The complete ELA model MATLAB code is publicly available [(https://github.com/durbank/ELA-model)](https://github.com/durbank/ELA-model), with `v0.1.0` the particular version used in this manuscript.
Detailed documentation on using the ELA model can also be found in the GitHub repository, as well as an example script demonstrating the model on four glacier test sites (see the Model Validation section for details).
In brief, the ELA model function `ELA_calc.m` requires two dataset inputs (discrete estimates of bed topography and discrete estimates of glacier width, both measured downglacier along the centerline of the glacier valley) and the number of Monte Carlo simulations to perform.
Approximately ten quasi-equally spaced points along the length of the glacier are often sufficient, though the optimum number depends on the length and complexity of the bed topography and glacier geometry.
To avoid issues of model extrapolation (and to automatically include the overall glacier length), both the toe and the head of the glacier should be included in these measurements.
The ELA model input data should be provided as a MATLAB structure with four fields, as summarized in Table 1.
Tributary glaciers, if present, should be provided as variable input arguments (formatted as MATLAB structures according to Table 1) after the number of simulations to perform.
The `format_inputs.m` function takes .csv files of glacier bed topography and glacier width measurements and creates a properly-formatted MATLAB structure to serve as input to the ELA model.

Table: Required format for ELA model inputs

| Field name  | Dimensions | Field description                                                                         |
|-------------|------------|-------------------------------------------------------------------------------------------|
|  `X_dist`   | $[N \times 1]$ |  Vector of glacier length from 0:N, where N is the total length of the glacier in meters. |
|  `Bed_pts`  | $[n \times 2]$ |  A matrix with positions along the glacier centerline (in meters) in the first column and corresponding bed elevation measurements (meters a.s.l.) in the second.  |
|  `Ice_surf` | $[n \times 2]$ | A matrix with positions along the glacier centerline (in meters) in the first column (this should match the first column in 'Bed_pts') and corresponding ice surface  elevation measurements (meters a.s.l.) in the second.  |
| `Width_pts` | $[m \times 2]$ | A matrix with positions along the glacier centerline (in meters) in the first column and corresponding glacier width measurements (meters) in the second (widths should orthogonally intersect the centerline). |

In addition to the inputs, there are model parameter assumptions built into the model prescribing the assumed errors for Monte Carlo sampling.
Updating these assumptions to better reflect specific input data is a simple matter of editing the assigned values.
Table 2 shows a summary of these parameters and their default values.

Table: ELA model error assumptions

| Variable name | Default value | Variable description                                            |
|---------------|---------------|-----------------------------------------------------------------|
|    `zSTD`     |     $25 \:meters$      | Standard deviation in measured glacier bed elevation. |
|    `wSTD`     |     $60 \:meters$      | Standard deviation in measured glacier width values.  |
|  `tau_STD`    | $5.0 \times 10^4 \:Pa$ | Standard deviation in estimated basal shear stress (used in ice thickness calculations). |
|    `rho`      |     $917 \:kg/m^3$     | Density of ice (used in ice thickness calculations). |
|     `g`       |     $9.8 \:m/s^2$      | Acceleration due to gravity (used in ice thickness calculations). |

For the development and validation of this model, we used a particular ArcGIS software workflow to generate the ELA model inputs.
We include this workflow as a diagram (Figure 2), but model inputs can be generated and provided using any desired methods, as long as they are properly formatted.

![Flowchart showing the ArcGIS workflow used to generate ELA model inputs. Orange denotes steps performed in ArcMap, while blue denotes steps performed in MATLAB. The first step is to generate a characteristic centerline for the glacier. This centerline can be drawn freehand or calculated in some other way. Then extract the bed elevation along the centerline using the DEM input (recorded as distance along the centerline), and save to a temporary .xls file. Import this file into MATLAB and use the `ice_thick.m` function (part of the ELA model) to estimate the ice surface elevation at points along the centerline transect. Import the ice surface results back to ArcMap and combine with the centerline transect values. The final steps require an outline of the glacier in question. These boundaries can be drawn from the aerial imagery for modern glaciers, or else from the moraines of paleoglaciers. In the case of paleoglacier moraines, the accumulation region of the glacier can be broadly defined by the valley boundaries. Calculate polylines at each discrete point along the transect at the elevation of the ice surface and orthogonal to the centerline at that point. The intersection of these orthogonal lines (at the elevation of the ice surface at that point) with either the glacier boundaries (in the case of modern glacier outlines and portions of paleoglaciers constrained by moraines) or the bed topography (in the case of the accumulation zone of paleoglaciers) defines the glacier width at each transect point. The results of distance down the glacier centerline, estimated bed elevation, and estimated glacier widths are then saved as a .csv file for import to the ELA model.](Figures/arc-flow.png)

## Model validation

We validate the ELA model by matching our reconstructions with direct observations of four modern glaciers in the European Alps.
These glaciers were selected due to the availability of data requisite for a data-model comparison (including present-day ice thickness, bed topography beneath the present-day glacier, mass balance measurements, aerial photography and DEMs).
These glaciers were further selected due to differences in overall shape, length, and elevation extent, thereby providing a wide range of possible glacier geometries.
This range of glacier characteristics enables a rigorous test of robustness and general applicability of the ELA model.
The four test glaciers are the Gries, Findel, Rhone, and Silvretta Glacier.
Three of these glaciers (Gries, Silvretta, and Findel) have continuous multi-year mass balance measurements from stake networks compiled by the World Glacier Monitoring Service (WGMS), and therefore make for the most compelling comparisons.
The Rhone Glacier has mass balance measurements from a handful of isolated years, providing a less certain, but still useful comparison to the model and other glaciers.

### Data sources

We obtained width and overall length measurements for the 4 validation glaciers from LANDSAT 5 satellite imagery and ASTER GDEM elvation models.
As the LANDSAT 5 imagery has a horizontal resolution of $\pm 30$ m, we prescribe a conservative $\pm 60$ m error for glacier width measurements (error for both edges of glacier boundaries).
ASTER GDEM data have a vertical root-mean-squared error of $\pm 15$ to $\pm 25$ m, depending on several environmental conditions (surface covering, topography, surface roughness, etc.) [@aster_aster_2009].
As our model exclusively involves mountainous snow-covered regions, we utilize the more conservative $\pm 25$ m error in calculations of bed topography and ice surface elevations.
Bed elevation validation measurements are from modeled topographies in @farinotti_method_2009 and @farinotti_simple_2010, constrained using multiple GPR profiles and/or borehole depths for each glacier.

The Silvretta and Gries glaciers have the best-constrained mass balances with ~50 years of published data for each [@wgms_fluctuations_2019].
In order to compare the current climatic ELA of these glaciers with our modeled ELA, we deterimine measured ELAs from the linearly detrended, annually-measured ELA values from 1981-2010 for both glaciers, with uncertainty calculated using a 95% margin of error.
The Findel Glacier has similarly well-constrained mass balance measurements from a glacier stake network [@wgms_fluctuations_2019], but with a much shorter record (2005-2010).
We compare the mean ELA over this time to the modeled ELA for Findel Glacier.
The Rhone Glacier does not have consistent year-to-year mass balance measurements.
Instead, we take modeled steady-state ELA estimates from air temperature correlations (1971-1990) provided in @zemp_distributed_2007.
These ELA estimates are constrained with the few years of available stake mass balances (mean $r^2$ between measured ELA and air temperature-correlated ELA is 0.89).
No uncertainty estimates were provided for the Rhone Glacier ELA.
For consistency, we assume Gaussian uncertainties with bounds similar to the margins of error of the mass balances for the Silvretta, Gries, and Findel glaciers ($\pm 50$ m).

### Model comparisons

![Bed elevation reconstructions for the four validation sites. Yellow circles denote measured bed elevation values, black lines represent the modeled bed profile, and blue shading represents model error (2 standard deviations).](Figures/Hypsometry.png)

![Modeled glacier ice surfaces for the four validation glaciers. Yellow circles denote measured ice elevation values, black lines represent the mean modeled bed topography (Figure 3), blue lines represent the modeled ice surface profile, and blue shading represents model error (2 standard deviations).](Figures/Ice.png)

![Glacier width modeling for the four validation sites. Compares the overall modeled areal profile (and modeled uncertainty) with discrete measured points of each glacier’s width. Yellow circles denote width measurements for points on the glacier, black lines represent the modeled width profile, and blue shading represents model error (2 standard deviations).](Figures/Width.png)

The model results, including bed topography, ice thickness, plan-profiles, and ELAs, are summarized in Figures 3-6 for all four validation sites.
Most of the intermediate model outputs match measured values within error.
Points of increased disagreement likely result mainly from local variability and the inherent smoothing caused by model fit constraints and optimzation.
Exceptions to this include the overdeepened section apparent in the Gries Glacier (Figure 3), which represents a systemic shift in bed topography not adequately captured in the model.
Similarly, most differences in modeled and measured ice surface (Figure 4) likely result from local variations in ice thickness of a scale finer than the input data resolution (e.g. ice crevasses), but with little effect on the final ELA estimate.
An exception to this explanation is Findel Glacier, wherein the model appears to systemically overestimate the ice thickness, and a corresponding overestimation of the ELA by a similar magnitude (see Figures 4 and 6).
Although isolating an exact reason for this overestimation is challenging, it may be related to violations of the assumed perfect plasticity of the modeled ice or to ice thinning/downwasting due to climate disequilibrium, neither of which are accounted for in this ELA model.
Modeled glacier width results generally closely match those recorded from satellite imagery (Figure 5).
The most noticeable exception to this is the Rhone Glacier, with a few clear outliers in the accumulation area.
These may be related to difficulties in accurately defining the glacier boundaries in the accumulation area, or else may simply represent a more complex glacier geometry that this ELA model will not fully capture.
Regardless, these deviations do not appear to significantly affect the final ELA estimate.

![Comparison of measured and modeled ELA values for the four validation glaciers. Modeled and measured estimates agree within error for 3 of the 4 glaciers. The results show a mean bias in central estimates for modeled ELAs of -13.5 m relative to measured ELAs, with no consistent direction in bias. The largest difference occurs with the Gries Glacier, with a central bias in modeled ELA of -155 m relative to the measured value.](Figures/ELAs.png)

Modeled ELA estimates for the four validation sites and comparisons to correpsonding ELA measurements are presented in Figure 6.
Three of the four validation glaciers show agreement within error between measured and modeled ELA values, with the exception being Gries Glacier, where the modeled ELA bounds fall 2.2 m outside the measured ELA bounds.
Likely sources of error to explain discrepancies between the results involve more complex considerations not accounted for with the simple ELA model.
For instance, more complex bed topographies, differences in shading/shielding by valley walls, debris cover, and accumulation through avalanching can all affect the recorded ELA in mass balance measurements, none of which are considered in the ELA model.
It is important to note that the model is particularly sensitive to errors in bed topography, as these values influence estimates of slope, ice thickness, and width and therefore can potentially strongly affect the final ELA estimates.
Differences in steady-state assumptions may also be an important factor in differences between modeled and measured modern ELAs.
The ELA model assumes steady-state conditions, whereas the annual mass balance reflects emergent climate conditions.
Glaciers typically have either an annual mass surplus or deficit in a given year, complicating comparisons of our results to measured ELA values.
Such a limitation, however, is inherent to all morphology-based ELA models.
Overall, the presented results show a high degree of confidence in the model's ability to estimate glacier ELAs (within calculated uncertainties) from relatively few geomorphic inputs, supporting the use of the presented ELA model for simple valley glaciers across a wide spectrum of bed slope geoemetries, glacier shapes, glacier widths, and elevation extents.

## Conclusions

The model described here accurately estimates ELAs from a variety of glacier sizes, shapes, topographies, and areal distributions while utilizing a small set of easily-obtained measurements.
The model provides errors based on the physical uncertainties of model inputs, a crucial factor for determining the significance and importance of results.
We validate the model on a set of glaciers in the Alps spanning a variety of characteristics (bed topography, size, shape, elevation extent, etc.).
Based on these validations and the physics-based nature of the model, this ELA model should serve as a robust, easily applicable, self-consistent method for ELA glacier reconstructions in varied areas, including the broader European Alps, alpine regions of the Arctic, the Southern Alps in New Zealand, and similar glaciated locations.
The model should also be readily applicable to paleoglacier reconstructions based on preserved moraine sequences, permitting rapid and consistent comparisons of glacier changes through time and across diverse regions.
Such studies will permit enhanced insight into the mechanisms of climate change in the past, and help us to better understand present and future changes to critical glacial and water resources in a warming world.

\pagebreak

## References
