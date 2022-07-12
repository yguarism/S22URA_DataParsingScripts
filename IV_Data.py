import numpy as np
import os
import pathlib
import scipy.io as sio
from FilesFromDirectory import FilesFromDirectory


class IV_Data:
    file_name = ""
    data_vg = []
    data_vd = []
    data_ig = []
    data_id = []
    vg_range = []
    vd_range = []
    vg_number_of_each = np.NaN
    vd_number_of_each = np.NaN
    vg_step = np.NaN
    vd_step = np.NaN
    ngf = np.NaN
    W = np.NaN
    L = np.NaN

    def __init__(self, file_path):
        if (os.path.isfile(file_path)):
            path = pathlib.Path(file_path)
            self.file_name = path.name
            extension = path.suffix

            if ".csv" in extension:
                print("CSV")
            
            elif ".mat" in extension:
                print("MAT")
                mat_contents = sio.loadmat(path)
                mat_struct = mat_contents["MeasurementIV"][0,0]
                self.ngf = mat_struct["NGF"][0,0]
                self.W = mat_struct["W"][0,0]
                self.L = mat_struct["L"][0,0]
                self.vg_step = mat_struct["VGstep"][0,0]
                self.vd_step = mat_struct["VDstep"][0,0]
                self.vd_step = mat_struct["VDstep"][0,0]
                self.vg_range = [mat_struct["VGStart"][0,0], mat_struct["VGStop"][0,0]]
                self.vd_range = [mat_struct["VDStart"][0,0], mat_struct["VDStop"][0,0]]
                self.data_vg = np.array(mat_struct["VGset"]).squeeze()
                self.data_vd = np.array(mat_struct["VDset"]).squeeze()
                self.data_ig = np.array(mat_struct["IGmeas"]).squeeze()
                self.data_id = np.array(mat_struct["IDmeas"]).squeeze()
                self.vg_number_of_each = np.count_nonzero(self.data_vg == self.vg_range[1])
                self.vd_number_of_each = np.count_nonzero(self.data_vd == self.vd_range[1])
            
            else:
                print("Not Valid Extension - must be csv or mat")

    def print_important_param(self):
        print(f"vg_step: {self.vg_step}, vg_range: {self.vg_range}, vd_step: {self.vd_step}, vd_range: {self.vd_range}, num_vg: {len(self.data_vg)}, num_vd: {len(self.data_vd)}")
        print(f"Number of Points: VG: {self.vg_number_of_each}  VD:{self.vd_number_of_each}")


dir_str = r"..\\..\\..\\OneDrive\\Documents\\University\\Fourth Year\\4A\\URA\\IV Raw Data"
files_obj = FilesFromDirectory(dir_str, "mat")
x = IV_Data(files_obj.relative_filepaths[1])
print(files_obj.relative_filepaths[1])
print(x.file_name)
x.print_important_param()
