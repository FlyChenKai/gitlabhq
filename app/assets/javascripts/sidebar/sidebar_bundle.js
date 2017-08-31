import Vue from 'vue';
import sidebarTimeTracking from './components/time_tracking/sidebar_time_tracking';
import sidebarAssignees from './components/assignees/sidebar_assignees';
import confidential from './components/confidential/confidential_issue_sidebar.vue';
import SidebarMoveIssue from './lib/sidebar_move_issue';
import lock from './components/lock/lock_issue_sidebar.vue';

import Mediator from './sidebar_mediator';

function mountConfidential(mediator) {
  const el = document.querySelector('#js-confidential-entry-point');
  const dataNode = document.getElementById('js-confidential-issue-data');
  const initialData = JSON.parse(dataNode.innerHTML);

  const ConfidentialComp = Vue.extend(confidential);

  new ConfidentialComp({
    propsData: {
      isConfidential: initialData.is_confidential,
      isEditable: initialData.is_editable,
      service: mediator.service,
    },
  }).$mount(el);
}

function mountLock(mediator) {
  const el = document.querySelector('#js-lock-entry-point');

  if (!el) return;

  const dataNode = document.getElementById('js-lock-issue-data');
  const initialData = JSON.parse(dataNode.innerHTML);

  const LockComp = Vue.extend(lock);

  new LockComp({
    propsData: {
      isLocked: initialData.is_locked,
      isEditable: initialData.is_editable,
      service: mediator.service,
    },
  }).$mount(el);
}

function domContentLoaded() {
  const sidebarOptions = JSON.parse(document.querySelector('.js-sidebar-options').innerHTML);
  const mediator = new Mediator(sidebarOptions);
  mediator.fetch();

  const sidebarAssigneesEl = document.querySelector('#js-vue-sidebar-assignees');
  // Only create the sidebarAssignees vue app if it is found in the DOM
  // We currently do not use sidebarAssignees for the MR page
  if (sidebarAssigneesEl) {
    new Vue(sidebarAssignees).$mount(sidebarAssigneesEl);
  }

  mountConfidential(mediator);
  mountLock(mediator);

  new SidebarMoveIssue(
    mediator,
    $('.js-move-issue'),
    $('.js-move-issue-confirmation-button'),
  ).init();

  new Vue(sidebarTimeTracking).$mount('#issuable-time-tracker');
}

document.addEventListener('DOMContentLoaded', domContentLoaded);

export default domContentLoaded;
