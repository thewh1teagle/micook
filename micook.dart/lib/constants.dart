final String modelEG1 = "chunmi.ihcooker.eg1";
final String modelEXP1 = "chunmi.ihcooker.exp1";
final String modelFW = "chunmi.ihcooker.chefnic";
final String modelHK1 = "chunmi.ihcooker.hk1";
final String modelKorea1 = "chunmi.ihcooker.korea1";
final String modelTW1 = "chunmi.ihcooker.tw1";
final String modelV1 = "chunmi.ihcooker.v1";

final List<String> modelVersion1 = [modelV1, modelFW, modelHK1, modelTW1];
final List<String> modelVersion2 = [modelEG1, modelEXP1, modelKorea1];
final List<String> supportedModels = [...modelVersion1, ...modelVersion2];

Map<String, int> deviceIds = {
  modelEG1: 4,
  modelEXP1: 4,
  modelFW: 7,
  modelHK1: 2,
  modelKorea1: 5,
  modelTW1: 3,
  modelV1: 1,
};
