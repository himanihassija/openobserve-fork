<!-- Custom homepage for our fork. Replaces upstream HomeView.vue as the
     root ("/") route. Deliberately simple per spec — this is the one page
     in the fork that's meant to diverge from upstream; everything else
     stays untouched so future rebases stay easy. -->
<template>
  <OPageLayout title="Home" icon="home" bleed>
    <div class="flex h-full flex-col items-center justify-center gap-y-4 text-center">
      <img
        class="h-16"
        src="@/assets/images/common/o2_logo.svg"
        alt="Company logo"
      />
      <div class="text-text-heading text-2xl font-semibold">
        Welcome
      </div>
      <div class="text-text-secondary max-w-md text-sm">
        <!-- TODO: replace with real copy once Chilarai signs off on wording -->
        This is your observability workspace. Use the sidebar to get to
        logs, traces, metrics, and dashboards.
      </div>
    </div>
  </OPageLayout>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import OPageLayout from "@/lib/core/PageLayout/OPageLayout.vue";

export default defineComponent({
  name: "CustomHome",
  components: { OPageLayout },
});
</script>
