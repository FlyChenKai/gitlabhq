import Vue from 'vue';
import store from '~/repo/stores';
import listCollapsed from '~/repo/components/commit_sidebar/list_collapsed.vue';
import { createComponentWithStore } from '../../../helpers/vue_mount_component_helper';
import { file } from '../../helpers';

describe('Multi-file editor commit sidebar list collapsed', () => {
  let vm;

  beforeEach(() => {
    const Component = Vue.extend(listCollapsed);

    vm = createComponentWithStore(Component, store);

    vm.$store.state.changedFiles.push(file(), file());
    vm.$store.state.changedFiles[0].tempFile = true;

    vm.$mount();
  });

  afterEach(() => {
    vm.$destroy();
  });

  it('renders added & modified files count', () => {
    expect(vm.$el.textContent.replace(/\s+/g, ' ').trim()).toBe('1 1');
  });
});
