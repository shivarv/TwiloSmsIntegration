import { LightningElement, api } from 'lwc';
import sentSmsToCustomerMethod from '@salesforce/apex/SentSmsController.sentSmsToCustomer';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class SentSms extends LightningElement {
    @api recordId;
    sentTwiloSms(event) {
        console.log('in sentTwiloSms');
        //var inp = this.template.querySelector("lightning-input");

        
        sentSmsToCustomerMethod({smsBody: inp.value, accountId: this.recordId}).then(result => {
            console.log('in sentSmsToCustomerMethod success');

            this.showNotification();
            this.dispatchEvent(new CloseActionScreenEvent());

        })
        .catch(error => {
            console.log('in error twillo' +error);
            this.showNotification();
            this.dispatchEvent(new CloseActionScreenEvent());

        }); 
    }

    showNotification() {
        console.log('in showNotification');

        const evt = new ShowToastEvent({
            title: 'SMS Sent!',
            message: 'Sms Sent Successfully',
            variant: { label: 'success', value: 'success' }
        });
        this.dispatchEvent(evt);
    }
}