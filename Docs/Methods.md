---
bibliography: [citations.bib]
csl: methodsx.csl
geometry: margin=1in
md_extensions: +grid_tables +table_captions
---

# Title: Name the ELA method explained below

## Abstract

Glaciers are widely used in paleoclimatic reconstructions, with their unique combination of large spatial footprint, direct response to climate, and near-global extent making them indispensable tools.[^motive1]
Although increasing computing power enables highly complex transient glacier modeling, the lack of detailed climatic data in the past typically requires paleoclimate studies to focus on computationally simple methods[^motive2] of reconstruction, frequently based on changes in a glacier’s geomorphic extent.[^motive3]
The equilibrium line altitude (ELA) of a glacier, as a direct measure of annual glacier mass balance, facilitates direct comparisons of climate by avoiding strong dependencies on glacier dynamics and by integrating the myriad variables that can drive changes in climate into a single metric.

[^motive1]: first sentence reads a bit complicated, I also would suggest to add urgent need to understand glacier response to ongoing climate as glaciers are key to hydrology etc...and I am not quite sure I know the difference between 'large spatial footprint' and 'near-global extent'. may be just say 'Due to xyc, glaciers have been widely used in paleoclimatic reconstructions.

[^motive2]: that's one way to look at it. From the data side, we simply have glacier record all over the planet, but all are point-measurements, and we need fast, versatile and flexible simple models to upscale and compare. Isn't that a gap you fill with this?

[^motive3]: Seems like there needs to be a transition here relating ELAs first to geomorphic extent, then to mass balance and climate.

Here we detail an ELA model that retains the simplicity of many other paleo-glacier reconstructions, but further incorporates physically-based assumptions that relate this estimate more directly and generally to glacier mass balance than statistical approaches[^abstract1].
The model is largely derived from a simple linear glacier-length model presented in [@oerlemans_minimal_2008], with modifications specific to quantifying ELAs and ELA changes.
We provide MATLAB functions and scripts of this model to provide a user-friendly and generally-applicable method to estimate glacier ELAs from easily-measured morphology parameters, with a particular emphasis on paleo-glacier reconstructions.
As a test of the model’s efficacy, we compare the model results for present-day glaciers in the Swiss Alps with previously published estimates of ELAs and intermediate model outputs.

[^abstract1]: which 'statistical approaches'? Not sure I understand this statement. Could you just say '...that relate the ELA estimate directly to glacier mass balance.'??

## Graphical abstract

![Graphical abstract describing the ELA modeling process used in this study.](Figures/graph-abstract.png)

## Methodological principles

This research presents a method to reconstruct ELA estimates based largely on physical relationships, while only requiring estimates of bed topography, glacier length, and glacier width.
This necessarily requires numerous simplifying assumptions, which ignore some details pertinent to individual glaciers.[^confused1]
Such details can be significant for some applications (e.g. dynamic modeling of glacier response, higher order surface energy and mass balance modeling, etc.), and other methods would be better suited to these circumstances.
The proposed model is specifically intended to estimate the ELA of snow-fed, clean ice, temperate glaciers with relatively simple bed and areal geometries.
This ELA model is similar in simplicity to field-based, geomorphic methods such as the toe-to-head area ratio (THAR) or accumulation area ratio (AAR) [@benn_mass_2000], but more physically-based rather than relying purely on empirical correlations.

[^confused1]: '...ignore selected details...', as you decided which one can be ignored here.

The ELA model also provides analytical constraints on the error associated with model outputs.[^errors1]
Such uncertainties help determine the significance and reliability of results, and are unfortunately not always adequately accounted for in paleoclimate research [@tarasov_data-calibrated_2012]. [^errors2]
Uncertainty estimates in this study are calculated based on Monte Carlo simulations of bootstrapped residuals of the input parameters.
These uncertainties give insight into the range of plausible ELA values based on both uncertainty of input parameters and the ability of the model assumptions to accurately represent those inputs.

[^errors1]: This is key! Could you add '..physical uncertainties...' somewhere??

[^errors2]: '...are fundamental..., but rigorous phyiscal uncertainties of ELA estimates are rarely presented in paleo-glacier research, because.....', some statement that 'physical uncertainties' are very hard to assign for THAR and AAR based ELAs and some of the applied models are of higher order, making error propagation complex...or something like that. Also, careful, as for example Andrew Macintosh's group gives 'physical errors', so does the U Maine group, but those are exceptions... so should we mention this somehow? 

### Balance equation

The fundamental basis of the ELA model is an integrated balance formula (Equation \ref{eq:balance}) for steady-state glaciers, adapted from @oerlemans_minimal_2008,

\begin{equation}
\label{eq:balance}
B_n = \int_0^L \dot{b}dx = \beta \int_0^L \left[ w(x) \left( H(x)+z(x)-ELA \right) \right]dx
\end{equation}

where $B_n$ is the total net balance, $x$ is the distance down glacier, $\dot{b}$ is the specific balance rate at $x$, $L$ is the glacier length, $\beta$ is the balance gradient, $w(x)$ is the glacier width at $x$, $H(x)$ the ice thickness at $x$, $z(x)$ represents the valley topography, and $ELA$ is the equilibrium line altitude.
In steady state conditions (like we assume for glaciers with well-developed moraine sequences), the total net balance is zero.
The balance gradient $\beta$ can be dropped in this case, and Equation \ref{eq:balance} can then be rearranged to solve for the $ELA$ (Equation \ref{eq:ela}).

\begin{equation}
\label{eq:ela}
ELA = \frac{\int_0^L w(x) H(x)dx + \int_0^L w(x) z(x)dx}{\int_0^L w(x) dx}
\end{equation}

We then estimate each of the three components ($H(x)$, $w(x)$, and $z(x)$) along the length of the glacier and solve for each component using trapezoidal numerical integration to derive an estimate for $ELA$.
Methods for the estimation of each of these components are detailed below.

### Glacier bed modeling

Bed topography measurements should follow a representative 1D line along the glacier profile, typically taken down the center of the glacier.
We then estimate $z(x)$ from a best-fit two-term exponential curve of this 1D profile line (\ref{eq:bed} 3), where $a$, $b$, $c$, and $d$ are fitting coefficients optimized in the model using the elevation data inputs (see Figure 2 for examples).
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
To model ice thickness profiles, we assume a parabolic distribution (true of a perfectly plastic glacier on a flat bed) around the mean ice thickness (see Figure 3 for examples).
The basal shear stress ($\tau$) is assumed to scale with ice thickness, following the relationship presented in [@haeberli_application_1995] (Equation \ref{eq:tau}), where $\Delta z$ is the difference between the minimum and maximum bed elevation.

$$
\Delta z > 1600 \:m \Longrightarrow \tau = 150 \:kPa
$$
\begin{equation}
\label{eq:tau}
500 \:m \le \Delta z \le 1600 \:m \Longrightarrow \tau = 0.005 + 1.598\Delta z - 0.435\Delta z^2 \:kPa
\end{equation}
$$
\Delta z < 500 \:m \Longrightarrow \tau = 3\Delta z \:kPa
$$

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
The model then performs least squares nonlinear curve fitting (again based on trust region techniques) on the initial parameter estimates to optimize the fit to the input width estimates (see Figure 4 for examples).

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
To avoid issues of model extrapolation, both the toe and the head of the glacier should be included in these measurements.
The ELA model input data should be provided as a MATLAB structure with four fields, as summarized in Table 1.
The `format_inputs.m` function takes .csv files of glacier bed topography and glacier width measurements and creates a properly-formatted MATLAT structure to serve as input to the ELA model.

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
|    `wSTD`     |     $50 \:meters$      | Standard deviation in measured glacier width values. |
|  `tau_STD`    | $5.0 \times 10^4 \:Pa$ | Standard deviation in estimated basal shear stress (used in ice thickness calculations). |
|    `rho`      |     $917 \:kg/m^3$     | Density of ice (used in ice thickness calculations). |
|     `g`       |     $9.8 \:m/s^2$      | Acceleration due to gravity (used in ice thickness calculations). |

For the development and validation of this model, we used a particular ArcGIS software workflow to generate the ELA model inputs.
We include this workflow as a diagram (Figure 1), but model inputs can be generated and provided using any desired methods, as long as they are properly formatted.

![Flowchart showing the ArcGIS workflow used to generate ELA model inputs. *This figure is still a work in progress.*](Figures/arc-flow.png)

## Model validation

We validate the ELA model by matching our reconstructions with direct observations of four modern glaciers in the European Alps.
These glaciers were selected due to the availability of data requisite for a data-model comparison (including present-day ice thickness, bed topography beneath the present-day glacier, mass balance measurements, aerial photography and DEMs).
The four test glaciers are the Gries, Findel, Rhone, and Silvretta Glacier.
These glaciers were further selected due to differences in overall shape, length, and elevation extent, thereby providing a wide range of possible glacier geometries.[^robust1]
Three of these glaciers (Gries, Silvretta, and Findel) have continuous multi-year mass balance measurements from stake networks compiled by the World Glacier Monitoring Service (WGMS), and therefore make for the most compelling comparisons.
The Rhone Glacier has mass balance measurements from a handful of isolated years, providing a less certain, but still useful comparison to the model and other glaciers.

[^robust1]: Give the two independent reasoning for selection of these glaciers together. Then say 'These four test glaciers are...'. Also, may be highlight once that this is a rather rigorous test for the model, because the glaciers are do different. You can connect to that later and state that the agreement between ELA data and model for all the four  glaciers is a strong indication that the model is functional for this problem.

### Data sources

We obtained width and overall length measurements for the 4 validation glaciers from aerial and satellite imagery.
Although exact margins of error for these data are unavailable, we assume an error[^error1] of ±25 m[^error2], a similar resolution to satellite images from NASA’s LANDSAT 5 database.
ASTER GDEMs, with a prescribed error of ±30 m[^error2], provided ice surface elevations, which we use in combination with measurements of bed topography to calculate ice thickness.
Bed elevations are from modeled topographies in @farinotti_method_2009 and @farinotti_simple_2010, constrained using multiple GPR profiles and/or borehole depths for each glacier.

[^error1]: may be strengthen this statement a bit? '..we assume an error of...' sounds kind of arbitrary given that we blow the horn about 'physical uncertainties...' above, no?

[^error2]: Vertical error?

[^error3]: Prescribed error in elevation?

[^ELA1]The Silvretta and Gries glaciers have the best-constrained mass balances with ~50 years of published data for each [@wgms_fluctuations_2019].
[^ELA2]In order to compare the current climatic ELA of these glaciers with our modeled ELA, we calculate the mean mass balance ELA from the linearly detrended annual ELA values from 1981-2010 for both glaciers[^ELA3], with uncertainty calculated using a 95% margin of error.
The Findel Glacier has similarly well-constrained mass balance measurements from a glacier stake network, but with a much shorter record (2005-2010), and we use the mean ELA to estimate the climatic ELA [@wgms_fluctuations_2019].
The Rhone Glacier does not have consistent year-to-year mass balance measurements.
Instead, we take modeled steady-state ELA estimates from air temperature correlations (1971-1990) provided in @zemp_distributed_2007.
These ELA estimates are constrained with the few years of available stake mass balances (mean $r^2$ between balance ELA and air temperature-correlated ELA is 0.89).
No uncertainty estimates were provided for the Rhone Glacier ELA.
For consistency, we assume Gaussian uncertainties with bounds similar to the margins of error of the mass balances for the Silvretta, Gries, and Findel glaciers (±50 m).

[^ELA1]: Why do I care about mass balance data? Have you discussed the link between mass balance and ELAs from observations yet? Just need to say ELAs can be derived from mass balance data, specifically defined as the elevation at which the mass balance equals zero.

[^ELA2]: THis is where things get a little confusing. You call the measured ELAs by multiple names. You need to state that the measured ELAs were derived from mass balance data (e.g., elevation where annual mass balance equals zero). Then talk about linearly detrending, averaging, etc. And use the same terminology throughout: I suggest "modeled ELA" and "data-derived ELA".  Or "measured ELA".

[^ELA3]: maybe this needs to be "In order to compare...our modeled ELAs, we calculate the data-derived ELAs by averaging the linearly detrended annual ELA values from 1981-2010..."

### Model comparisons

![Bed elevation reconstructions for the four validation sites. Yellow circles denote measured bed elevation values, black lines represent the modeled bed profile, and blue shading represents model error (±2 standard deviations).](Figures/Hypsometry.png)

![Modeled glacier ice surfaces for the four validation glaciers. Yellow circles denote measured ice elevation values, black lines represent the mean modeled bed topography (Figure 1), blue lines represent the modeled ice surface profile, and blue shading represents model error (±2 standard deviations).](Figures/Ice.png)

![Glacier width modeling for the four validation sites. Compares the overall modeled areal profile (and modeled uncertainty) with discrete measured points of each glacier’s width. Yellow circles denote width measurements for points on the glacier, black lines represent the modeled width profile, and blue shading represents model error (±2 standard deviations).](Figures/Width.png)

![Comparison of measured and modeled ELA values for the four validation glaciers. (Still a few details to work out for this figure...)](Figures/ELAs.png)[^consistent1]

[^consistent1]: If you choose "measured" ELA, then use that throughout. Or use "data-derived" ELA. Just be consistent.

The model results[^outputs1], including bed topography, ice thickness, plan-profiles, and ELAs, are summarized in Figures 2-5 for all four validation sites.
Most of the intermediate model outputs match measured values within error.
One added strength of this model is such intermediate outputs allow for increased diagnostics on model performance or troubleshooting.[^order1]

[^outputs1]: I am not sure you mention explicitly somewhere, what you actually model. Should do that above.

[^order1]: This sentence is good, but not in the right place. You should continue to discuss where the model-data comparison matches, and -more importantly- where it does not match and why  (and why the mismatch is no drama).

ELA estimates for the four validation sites and comparisons to correpsonding ELA measurements are presented in Figure 5.
Differences in steady-state assumptions may be an important factor in differences between modeled and measured modern ELAs.
The ELA model assumes steady-state conditions, whereas the annual mass balance reflects emergent climate conditions.
Glaciers typically have either an annual mass surplus or deficit in a given year, complicating comparisons of our results to mass balance ELA measurements.
Such a limitation, however, is inherent to all morphology-based ELA models.
Regardless of the source of observed deviations, the results indicate the ELA model estimates the ELA within prescribed error relative to mass balance measurements for all four validation glaciers.
Such results lend strong support for the veracity of this ELA model for simple valley glaciers.[^conclusions]

[^conclusions]: Durban and Summer: do you think you can elaborate a bit more here, and may be mention, where the model would be useful, may be even mention Arctic (Norway), Alps, NZ etc....? And should we consider to reconnect to the glacier chronologies and add one sentence that this model can be used to upscale from and compare robust paleo-glacier reconstructions?

\pagebreak

## References
