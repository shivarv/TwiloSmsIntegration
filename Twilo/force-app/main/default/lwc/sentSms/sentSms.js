import { LightningElement, api } from 'lwc';
import sentSmsToCustomerMethod from '@salesforce/apex/SentSmsController.sentSmsToCustomer';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class SentSms extends LightningElement {
    constructor() {
        super();
    }

    @api recordId;
    sentTwiloSms(event) {
        var inp = this.template.querySelector("lightning-textarea");
//tteest
        
        if(!input || !input.value ||  (input.value.length === 0 )) {
            alert('Empty string, please enter the message before typing sent');
        }
        sentSmsToCustomerMethod({smsBody: inp.value, accountId: this.recordId}).then(result => {
            console.log('in sentSmsToCustomerMethod success');

            this.showNotification();
            this.dispatchEvent(new CloseActionScreenEvent());

        })
        .catch(error => {
            this.showNotification();
            this.dispatchEvent(new CloseActionScreenEvent());

        }); 
    }

    showNotification() {

        const evt = new ShowToastEvent({
            title: 'SMS Sent!',
            message: 'Sms Sent Successfully',
            variant: { label: 'success', value: 'success' }
        });
        this.dispatchEvent(evt);
    }
}