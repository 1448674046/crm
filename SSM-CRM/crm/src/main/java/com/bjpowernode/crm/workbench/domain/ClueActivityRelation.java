package com.bjpowernode.crm.workbench.domain;

public class ClueActivityRelation {

    private String id;
    private String clueId;
    private String activityId;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = (id == null? null: id);
    }

    public String getClueId() {
        return clueId;
    }

    public void setClueId(String clueId) {
        this.clueId = (clueId == null? null: clueId);
    }

    public String getActivityId() {
        return activityId;
    }

    public void setActivityId(String activityId) {
        this.activityId = (activityId == null? null: activityId);
    }
}
