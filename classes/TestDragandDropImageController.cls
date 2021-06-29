@IsTest(SeeAllData = true)
public class TestDragandDropImageController {
    @isTest public static void saveChunk() {
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S';
        cVersion.PathOnClient = 'Test.jpg';
        cVersion.Origin = 'C';
        cVersion.OwnerId = userinfo.getuserid();
        cVersion.Title = 'Test';
        cVersion.VersionData = EncodingUtil.base64Decode('Test Data');
        Insert cVersion;
        string urls = 'iVBORw0KGgoAAAANSUhEUgAAAoAAAAHgCAIAAAC6s0uzAACAAElEQVR42lz92ZJcV7IlCC5V3WY+jwABMqYbNzNLskRKWqT//7F+oV+qurPuEMEBBOCjuY1nq65+UN3HnJdCiQEk4Gbn7EF16Rrk//w//28yVAATUaMSBEVIfry9PDtrEJmm/vXrq6iSJCkCAiKC/E8SIiSA/L0QERH8+MMt2CNE1d7Wu8fV5vJ0eX93LsDCFIKvD2/rXb+5PL2+Oo0IAIz49rgKCgBAJP9EQCD0MMAjSKGagHAPAmaqQYJ0QAABVFX//NM1O0T4/Lp7fd1YEwqCQIAAADNEECCp+UVESFJVTk5P7m/PFdI9GPz25fnQ/e724vrulDQg3PnwuPKI+7vLy7NF705p2820enkNVQpAAgJAVfK5iAogIhruDIqKqgIBCAPBACkhIXJ9ubi7uwRpuvj1t6f9/gBATKAiKsg/jgG';
        DragandDropImageController.saveChunk(userinfo.getuserid(), '572d179a38370e317b1c34f63785e7de.png', urls, 'jpg', '');
    }

    @isTest public static void apendSave() {
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S';
        cVersion.PathOnClient = 'Test.jpg';
        cVersion.Origin = 'C';
        cVersion.OwnerId = userinfo.getuserid();
        cVersion.Title = 'Test';
        cVersion.VersionData = EncodingUtil.base64Decode('Test Data');
        Insert cVersion;
        string urls = 'iVBORw0KGgoAAAANSUhEUgAAAoAAAAHgCAIAAAC6s0uzAACAAElEQVR42lz92ZJcV7IlCC5V3WY+jwABMqYbNzNLskRKWqT//7F+oV+qurPuEMEBBOCjuY1nq65+UN3HnJdCiQEk4Gbn7EF16Rrk//w//28yVAATUaMSBEVIfry9PDtrEJmm/vXrq6iSJCkCAiKC/E8SIiSA/L0QERH8+MMt2CNE1d7Wu8fV5vJ0eX93LsDCFIKvD2/rXb+5PL2+Oo0IAIz49rgKCgBAJP9EQCD0MMAjSKGagHAPAmaqQYJ0QAABVFX//NM1O0T4/Lp7fd1YEwqCQIAAADNEECCp+UVESFJVTk5P7m/PFdI9GPz25fnQ/e724vrulDQg3PnwuPKI+7vLy7NF705p2820enkNVQpAAgJAVfK5iAogIhruDIqKqgIBCAPBACkhIXJ9ubi7uwRpuvj1t6f9/gBATKAiKsg/jgG';
        DragandDropImageController.saveChunk(userinfo.getuserid(), '572d179a38370e317b1c34f63785e7de.png ', urls, 'jpg', cVersion.Id);
    }
}