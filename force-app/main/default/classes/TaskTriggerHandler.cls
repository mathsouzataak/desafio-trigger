public with sharing class TaskTriggerHandler {
    public TaskTriggerHandler() {

    }

    public void beforeInsert(List<Task> tarefas) {
        List<Task> tasksEmAberto = [SELECT Id, WhatId, Status FROM Task WHERE Status NOT IN ('Completed', 'Deferred') AND What.Type In ('Case')];

        for (Task tarefa : tarefas) {

            if (tarefa.Status == 'Completed' || tarefa.Status == 'Deferred' || tarefa.WhatId == null) {
                continue;
            }

            for (Task taskDb : tasksEmAberto) {
                if (taskDb.WhatId == tarefa.WhatId) {
                    tarefa.addError('Já existe uma tarefa em aberto nesse caso. Encerre-a antes de abrir uma nova.');
                    break;
                }
            }
        }
    }
}