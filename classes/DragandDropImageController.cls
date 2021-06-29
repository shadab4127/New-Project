public with sharing class DragandDropImageController { 
     public class userWrapper {
        @AuraEnabled
        public String userId { get; set; }
        @AuraEnabled
        public String fullphotourl { get; set; }
    }
    // used in the component: DragandDropImage
    // this method is used to save the image as a display picture on the user setting.
    @AuraEnabled
    public static Id saveChunk(Id parentId, String fileName, String base64Data, String contentType, String fileId) {
        if (fileId == '') {
            fileId = saveTheFile(parentId, fileName, base64Data, contentType);
            system.debug('if loop');
        } else {
            appendToFile(fileId, base64Data,contentType,fileName,parentId);
            system.debug('else loop');
        }
        return Id.valueOf(fileId);
    }
    
    // this method is used to save the image as a display picture on the user setting.
    public static Id saveTheFile(Id parentId, String fileName, String base64Data, String contentType) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Id userId = UserInfo.getUserId();
        NetworkMember membership = [SELECT networkID, memberID FROM NetworkMember WHERE memberID = :userId];
        ContentVersion cVersion = new ContentVersion();
        cVersion.ContentLocation = 'S';
        cVersion.PathOnClient = fileName;
        cVersion.Origin = 'C';
        cVersion.OwnerId = parentId;
        cVersion.Title = fileName;
        cVersion.VersionData = EncodingUtil.base64Decode(base64Data);
        Insert cVersion;
        setPhoto(membership.NetworkId,userId,new ConnectApi.BinaryInput(cVersion.VersionData,'image/jpg',cVersion.Title));
        return cVersion.Id;
    }
    
   public static ConnectApi.Photo setPhoto(String communityId, String userId, ConnectApi.BinaryInput fileUpload) {
        ConnectApi.Photo photo = ConnectApi.UserProfiles.setPhoto(communityId, userId, fileupload);    
        return photo;
    }
    // this method is used to update the image as a display picture on the user setting.
    private static void appendToFile(Id fileId, String base64Data,String contentType,String fileName,Id parentId) {
        Blob blb; 
        String title;
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Id userId = UserInfo.getUserId();
        NetworkMember membership = [SELECT networkID, memberID FROM NetworkMember WHERE memberID = :userId];
        List<ContentVersion> cvlist = [SELECT Id, PathOnClient,OwnerId,VersionData,Title
                                       FROM ContentVersion
                                       WHERE Id =: fileId AND isMajorVersion = false LIMIT 1];
        if (cvlist.size() > 0) {
            String existingBody = EncodingUtil.base64Encode(cvlist[0].VersionData);
            cvlist[0].VersionData = EncodingUtil.base64Decode(existingBody + base64Data);
            update cvlist;
            blb = cvlist[0].VersionData;
            title = cvlist[0].Title;
        } else {
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = 'S'; 
            cVersion.PathOnClient = fileName;
            cVersion.Origin = 'C';
            cVersion.OwnerId = parentId;
            cVersion.Title = fileName;
            cVersion.VersionData = EncodingUtil.base64Decode(base64Data);
            cVersion.isMajorVersion = false;
            Insert cVersion;
            blb = cVersion.VersionData;
            title = cVersion.Title;
        }  
      setPhoto(membership.NetworkId,userId,new ConnectApi.BinaryInput(blb,'image/jpg',title));
    }
    
    @AuraEnabled
    public static userWrapper getUser() {
        User usr = [Select SmallPhotoUrl,FullPhotoUrl,Id From User  
                    WHERE Id=:UserInfo.getUserId()];
        userWrapper uw = new userWrapper();
        if (usr != null) {
            uw.userId = usr.Id;
            uw.fullphotourl = usr.FullPhotoUrl;
        }
      return uw; 
    }
}