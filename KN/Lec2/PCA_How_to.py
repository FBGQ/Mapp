#PCA

# First open the tif file

dataset = gdal.Open(r'yukon.tif')

# get the bands and transform them in arrays

band1 = dataset.GetRasterBand(1) # Blue channel
band2 = dataset.GetRasterBand(2) # Red channel
band3 = dataset.GetRasterBand(3) # Green channel
band4 = dataset.GetRasterBand(4) # NIR channel
band5 = dataset.GetRasterBand(5) # SWIR1 channel
band6 = dataset.GetRasterBand(6) # SWIR2 channel
b1 = band1.ReadAsArray()
b2 = band2.ReadAsArray()
b3 = band3.ReadAsArray()
b4 = band4.ReadAsArray()
b5 = band5.ReadAsArray()
b6 = band6.ReadAsArray()

# Reshape them and put them in a matrix

# transform b1 into a array of 1 dimension
b1_a = np.reshape(b1, (b1.shape[0]*b1.shape[1]))
b2_a = np.reshape(b2, (b2.shape[0]*b2.shape[1]))
b3_a = np.reshape(b3, (b3.shape[0]*b3.shape[1]))
b4_a = np.reshape(b4, (b4.shape[0]*b4.shape[1]))
b5_a = np.reshape(b5, (b5.shape[0]*b5.shape[1]))
b6_a = np.reshape(b6, (b6.shape[0]*b6.shape[1]))

# stack the 6 bands in a single matrix
bands = np.column_stack((b1_a, b2_a, b3_a, b4_a, b5_a, b6_a))



# -------- Here we start ---------- #

# Standardize the data
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
bands_scaled = scaler.fit_transform(bands)

pca = PCA(n_components=6)
princ_comp = pca.fit_transform(bands_scaled)

# print variants of components
variants_ratio = pca.explained_variance_ratio_
print(pca.explained_variance_ratio_ * 100)

# print the components
components = pca.components_
print(pca.components_)

# Data can be projected onto the PCA space by using the dot-product
projected_data = pca.transform(bands_scaled)
pc_proj = projected_data
