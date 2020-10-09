---
bibliography: [citations.bib]
csl: methodsx.csl
---

# A first-order flexible ELA model based on geomorphic constraints

This page documents a flexible model to estimate steady-state equilibrium line altitudes (ELAs) of clean-ice, temperate alpine glaciers based on geomorphic inputs.
The method is detailed in full in the accompanying paper (Keeler et al., 2020).
In this README file, we present a brief overview of the uses and limitations of the model, along with a brief tutorial of how to use the model.
Please cite the original paper when using this model.

Alpine glaciers, with their valuable combination of highly sensitive response to climate and near-global extent, are powerful tools for investigating previous and present climate changes.
They also represent critical water resources for areas around the globe, with the potential for far-reaching effects in a warming world.
Advancements to understand and model glacial changes and the variables influencing them are therefore paramount.
Many glacier models fall into one of two endmembers: either highly complex transient models requiring careful tuning of multiple parameters to individual glaciers, or basic empirical correlations of glacier area and length with few considerations for local and regional variations in characteristics.
This page contains code for a physical steady-state model for alpine glaciers relating directly to glacier mass balance (via the equilibrium line altitude) while retaining the simplicity of other morphology methods, and simultaneously including error estimates.
We provide custom MATLAB functions as a user-friendly and generally-applicable method to estimate glacier equilibrium line altitudes from only a limited number of glacier bed topography and glacier width measurements.

The primary functions of the ELA model are located in the `src/` directory.
The ELA model function `ELA_calc.m` requires two dataset inputs (discrete estimates of bed topography and discrete estimates of glacier width, both measured downglacier along the centerline of the glacier valley) and the number of Monte Carlo simulations to perform.
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

## Misc notes

The example script utilizes a function called `shadedErrorBar`.
This was developed by Rob Campbell and can be found on [his Github page](https://github.com/raacampbell/shadedErrorBar).
