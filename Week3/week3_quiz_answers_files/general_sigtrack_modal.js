define(["jquery","js/lib/modals","pages/spark/models/course.json","js/lib/coursera"],function($,Modal,Course,Coursera){var signatureModal=function($,Modal){var GeneralModal=function(el){this.$el=$(el),this.modal=new Modal(this.$el,{"overlay.class":"coursera-signature-modal-overlay-darker","overlay.close":!1})};return GeneralModal.prototype.open=function(){this.modal.open()},GeneralModal.prototype.setDoingWell=function(url){$(".course-signaturetrack-modal-learnmore").on("click",function(){window.open(url)}),this.modal.on("close",function(){Coursera.api.get("signature/user/set_doing_well")})},GeneralModal.prototype.close=function(){this.modal.close()},GeneralModal};return signatureModal($,Modal)});