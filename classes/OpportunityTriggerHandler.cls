public class OpportunityTriggerHandler {
    // プロパティ
    private Boolean m_isExecuting = false;
    private Integer batchSize = 0;
    
    /**
     * コンストラクタ
     */
    public OpportunityTriggerHandler(Boolean isExecuting, Integer size) {
        this.m_isExecuting = isExecuting;
        this.batchSize = size;
    }

    /**
     * 更新後イベント
     */
    public void onAfterUpdate(Opportunity[] oldObjs, Map<ID, Opportunity> oldObjMap, Opportunity[] newObjs, Map<ID, Opportunity> newObjMap) {
        // 親商談が更新されたら子商談を更新する
        this.updateChildOpp(newObjs);
    }

    /**
     * 親商談が更新されたら子商談を更新する
     * @param newObjs
     * @return なし
     */
    private void updateChildOpp (Opportunity[] newObjs) {
        List<Id> parentIdList = new List<Id>();
        
        // 更新対象の商談件数分繰り返す
        for (Opportunity opp : newObjs) {
            // 親商談に紐づく子商談を取得する
            parentIdList.add(opp.Id);
        }

        // 子商談用のクエリ
        String query = 'SELECT Id, ';
        // 案件基本情報(OppDefaultInfo)の項目セットからクエリで取得する対象のAPI名を取得する
        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.OppDefaultInfo.getFields()) {
            query += f.getFieldPath() + ', ';
        }

        // 親商談との比較用クエリ
        String parentQuery = '';
        // 案件基本情報(OppDefaultInfo)の項目セットからクエリで取得する対象のAPI名を取得する
        for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.OppDefaultInfo.getFields()) {
            parentQuery += 'OrgOpportunity__r.' + f.getFieldPath() + ', ';
        }
        query += parentQuery;
        query += ' OrgOpportunity__c FROM Opportunity WHERE OrgOpportunity__c IN :parentIdList';
        
        // 商談から子商談および親商談の情報を取得する
        List<Opportunity> childOppList = Database.query(query);

        List<Opportunity> updateList = new List<Opportunity>();
        for (Opportunity opp : childOppList) {
            Boolean addFlg = false;
            for(Schema.FieldSetMember f : SObjectType.Opportunity.FieldSets.OppDefaultInfo.getFields()) {
                // 子商談の項目セットの値を親商談の値が違う場合はセットする
                if (opp.get(f.fieldPath) != opp.OrgOpportunity__r.get(f.fieldPath)) {
                    opp.put(f.fieldPath, opp.OrgOpportunity__r.get(f.fieldPath));
                    // 1件でも追加された場合は更新用のリストへ加える
                    addFlg = true;
                }
            }
            // 更新対象のみupdate用リストにくわえる
            if (addFlg) {
                updateList.add(opp);
            }
        }
        // 子商談を更新する
        if (!updateList.isEmpty()) {
            update updateList;
        }
    }
}